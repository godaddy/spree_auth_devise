require 'spec_helper'

describe Spree::UsersController do
  let(:admin_user) { create(:user) }
  let(:user) { create(:user) }
  let(:role) { create(:role) }

  before do
    controller.stub spree_current_user: user
  end

  context '#create' do
    it 'create a new user' do
      spree_post :create, { user: { email: 'foobar@example.com', password: 'foobar123', password_confirmation: 'foobar123' } }
      expect(assigns[:user].new_record?).to be_false
    end
  end

  context '#update' do

    context 'updating own account with correct current password' do
      it 'updates email' do
        expect{spree_put :update, { user: {email: 'email@email.com', current_password: 'secret'} }}.to change{Spree::User.find(user).email}
      end
    end

    context 'updating own account' do
      it 'fails with incorrect password' do
        expect{spree_put :update, { user: {email: 'email@email.com', current_password: 'incorrectPassword'} }}.to_not change{Spree::User.find(user).email}
      end
      it 'fails without current password' do
        expect{spree_put :update, { user: {login: 'email@email.com'} }}.to_not change{Spree::User.find(user).email}
      end
    end

    it 'does not update roles' do
      spree_put :update, user: { spree_role_ids: [role.id] }
      expect(assigns[:user].spree_roles).to_not include role
    end
  end
end
