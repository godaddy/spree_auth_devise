require 'spec_helper'

describe Spree::CheckoutController do
  let(:order) { create(:order_with_totals, email: nil, user: nil) }
  let(:user)  { mock_model Spree::User, last_incomplete_spree_order: nil, has_spree_role?: true, spree_api_key: 'fake' }
  let(:token) { 'some_token' }

  before do
    allow(controller).to receive(:current_order).and_return(order)
    allow(order).to receive(:confirmation_required?).and_return(true)
  end

  context '#edit' do
    context 'when registration step enabled' do
      before do
        allow(controller).to receive(:check_authorization)
        Spree::Auth::Config.set(registration_step: true)
      end

      context 'when authenticated as registered user' do
        before { allow(controller).to receive(:spree_current_user).and_return(user) }

        it 'proceed to the first checkout step' do
          expect(user).to receive(:ship_address)

          spree_get :edit, { state: 'address' }
          expect(response).to render_template :edit
        end
      end

      context 'when authenticated as guest' do
        it 'redirect to registration step' do
          spree_get :edit, { state: 'address' }
          expect(response).to redirect_to spree.checkout_registration_path
        end
      end
    end

    context 'when registration step disabled' do
      before do
        Spree::Auth::Config.set(registration_step: false)
        allow(controller).to receive(:check_authorization)
      end

      context 'when authenticated as registered' do
        before { allow(controller).to receive(:spree_current_user).and_return(user) }

        it 'proceed to the first checkout step' do
          expect(user).to receive(:ship_address)

          spree_get :edit, { state: 'address' }
          expect(response).to render_template :edit
        end
      end

      context 'when authenticated as guest' do
        it 'proceed to the first checkout step' do
          spree_get :edit, { state: 'address' }
          expect(response).to render_template :edit
        end
      end
    end
  end

  context '#update' do
    context 'when in the confirm state' do
      before do
        order.update_column(:email, 'spree@example.com')
        order.update_column(:state, 'confirm')

        # So that the order can transition to complete successfully
        allow(order).to receive(:payment_required).and_return(false)
      end

      context 'with a token' do
        before do
          allow(order).to receive(:token).and_return('ABC')
        end

        it 'redirect to the tokenized order view' do
          spree_post :update, { state: 'confirm' }, { access_token: 'ABC' }
          expect(response).to redirect_to spree.token_order_path(order, 'ABC')
          expect(flash.notice).to eq Spree.t(:order_processed_successfully)
        end
      end

      context 'with a registered user' do
        before do
          allow(controller).to receive(:spree_current_user).and_return(user)
          allow(order).to receive(:user).and_return(user)
          allow(order).to receive(:token).and_return(nil)
        end

        it 'redirect to the standard order view' do
          spree_post :update, { :state => 'confirm' }
          expect(response).to redirect_to spree.order_path(order)
        end
      end
    end
  end

  context '#registration' do
    it 'does not check registration' do
      allow(controller).to receive(:check_authorization)
      controller.should_not_receive(:check_registration)
      spree_get :registration
    end

    it 'check if the user is authorized for :edit' do
      expect(controller).to receive(:authorize!).with(:edit, order, token)
      spree_get :registration, {}, { access_token: token }
    end
  end

  context '#update_registration' do
    let(:user) { user = mock_model Spree::User }

    it 'does not check registration' do
      allow(controller).to receive(:check_authorization)
      allow(order).to receive(:update_attributee).and_return(true)
      controller.should_not_receive :check_registration
      spree_put :update_registration, { order: { } }
    end

    it 'render the registration view if unable to save' do
      allow(controller).to receive(:check_authorization)
      spree_put :update_registration, { order: { email: 'invalid' } }
      expect(flash[:registration_error]).to eq I18n.t(:email_is_invalid, scope: [:errors, :messages])
      expect(response).to render_template :registration
    end

    it 'redirect to the checkout_path after saving' do
      allow(order).to receive(:update_attributes).and_return(true)
      allow(controller).to receive(:check_authorization)
      spree_put :update_registration, { order: { email: 'jobs@spreecommerce.com' } }
      expect(response).to redirect_to spree.checkout_path
    end

    it 'check if the user is authorized for :edit' do
      allow(order).to receive(:update_attributes).and_return(true)
      expect(controller).to receive(:authorize!).with(:edit, order, token)
      spree_put :update_registration, { order: { email: 'jobs@spreecommerce.com' } }, { access_token: token }
    end
  end
end
