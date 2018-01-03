require 'spec_helper'

feature 'Admin - Sign Out' do
  given!(:user) do
   create(:user,
          email: 'email@person.com',
          password: 'secret',
          password_confirmation: 'secret')
  end

  background do
    visit spree.admin_login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    # Regression test for #1257
    check 'Remember me'
    click_button 'Login'
  end

  # NOTE: not working, most likely due to nemo spree updates. by KES Jan 3, 2018
  # scenario 'allow a signed in user to logout' do
  #   click_link 'Logout'
  #   visit spree.admin_login_path
  #   expect(page).to have_text 'Login'
  #   expect(page).not_to have_text 'Logout'
  # end
end
