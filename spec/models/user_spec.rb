# frozen_string_literal: true

describe Spree::User do
  before(:all) { Spree::Role.create name: 'admin' }

  it '#admin?' do
    expect(create(:admin_user).admin?).to be true
    expect(create(:user).admin?).to be false
  end

  it 'generate the reset password token' do
    user = build(:user)
    expect(user.reset_password_token).not_to be_nil
  end

  context '#destroy' do
    it 'can not delete if it has completed orders' do
      order = build(:order, completed_at: Time.now)
      order.save
      user = order.user

      expect { user.destroy }.to raise_exception(Spree::User::DestroyWithOrdersError)
    end
  end
end
