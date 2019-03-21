# frozen_string_literal: true

RSpec.describe Spree::UsersController do
  let(:admin_user) { FactoryBot.create(:user) }
  let(:user) { FactoryBot.create(:user) }
  let(:role) { FactoryBot.create(:role) }

  before do
    allow(controller).to receive(:spree_current_user).and_return(user)
  end

  context '#load_object' do
    it 'redirects to login path if user is not found' do
      allow(controller).to receive(:spree_current_user) { nil }
      spree_put :update, { user: { email: 'foobar@example.com' } }
      expect(response).to redirect_to spree.login_path
    end
  end

  context '#create' do
    it 'create a new user' do
      spree_post :create, { user: { email: 'foobar@example.com', password: 'foobar123', password_confirmation: 'foobar123' } }
      expect(assigns[:user].new_record?).to be false
    end
  end

  context '#update' do
    context 'when updating own account' do
      it 'perform update' do
        spree_put :update, { user: { email: 'mynew@email-address.com' } }
        expect(assigns[:user].email).to eq 'mynew@email-address.com'
        expect(response).to redirect_to spree.account_url(only_path: true)
      end
    end

    it 'does not update roles' do
      spree_put :update, user: { spree_role_ids: [role.id] }
      expect(assigns[:user].spree_roles).to_not include role
    end
  end
end
