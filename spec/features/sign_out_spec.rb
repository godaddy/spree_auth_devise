require 'spec_helper'

feature 'Sign Out' do
  given!(:user) do
   create(:user,
          email: 'email@person.com',
          password: 'secret',
          password_confirmation: 'secret')
  end

  background do
    visit spree.login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    # Regression test for #1257
    check 'Remember me'
    click_button 'Login'
  end

end
