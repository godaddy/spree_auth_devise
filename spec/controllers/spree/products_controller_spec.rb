# frozen_string_literal: true

describe Spree::ProductsController do
  let!(:product) { create(:product, available_on: 1.year.from_now) }
  let!(:user)    { mock_model(Spree::User, spree_api_key: 'fake', last_incomplete_spree_order: nil) }

  it 'allows admins to view non-active products' do
    allow(controller).to receive(:before_save_new_order)
    allow(controller).to receive(:spree_current_user).and_return(user)
    allow(user).to receive(:has_spree_role?).and_return(true)
    spree_get :show, id: product.to_param
    expect(response.status).to eq(200)
  end

  it 'cannot view non-active products' do
    allow(controller).to receive(:before_save_new_order)
    allow(controller).to receive(:spree_current_user).and_return(user)
    allow(user).to receive(:has_spree_role?).and_return(false)
    spree_get :show, id: product.to_param
    expect(response.status).to eq(404)
  end
end
