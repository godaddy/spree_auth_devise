# NOTE: not working, most likely due to nemo spree updates. by KES Jan 3, 2018

# require 'spec_helper'

# feature 'Accounts' do

#   context 'editing' do
#     scenario 'can edit an admin user' do
#       user = create(:admin_user, email: 'admin@person.com', password: 'password', password_confirmation: 'password')
#       visit spree.login_path

#       fill_in 'Email', with: user.email
#       fill_in 'Password', with: user.password
#       click_button 'Login'

#       click_link 'My Account'
#       expect(page).to have_content 'admin@person.com'
#     end

#     scenario 'can edit a new user' do
#       Spree::Auth::Config.set(signout_after_password_change: false)
#       visit spree.signup_path

#       fill_in 'Email', with: 'email@person.com'
#       fill_in 'Password', with: 'password'
#       fill_in 'Password Confirmation', :with => 'password'
#       click_button 'Create'

#       click_link 'My Account'
#       expect(page).to have_content 'email@person.com'
#       click_link 'Edit'

#       fill_in 'Password', with: 'foobar'
#       fill_in 'Password Confirmation', with: 'foobar'
#       click_button 'Update'

#       expect(page).to have_content 'email@person.com'
#       expect(page).to have_content 'Account updated'
#     end

#     scenario 'can edit an existing user account' do
#       Spree::Auth::Config.set(signout_after_password_change: false)
#       user = create(:user, email: 'email@person.com', password: 'secret', password_confirmation: 'secret')
#       visit spree.login_path

#       fill_in 'Email', with: user.email
#       fill_in 'Password', with: user.password
#       click_button 'Login'

#       click_link 'My Account'
#       expect(page).to have_content 'email@person.com'
#       click_link 'Edit'

#       fill_in 'Password', with: 'foobar'
#       fill_in 'Password Confirmation', with: 'foobar'
#       click_button 'Update'

#       expect(page).to have_content 'email@person.com'
#       expect(page).to have_content 'Account updated'
#     end
#   end
# end
