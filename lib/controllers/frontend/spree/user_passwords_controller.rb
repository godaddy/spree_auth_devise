# frozen_string_literal: true

class Spree::UserPasswordsController < Devise::PasswordsController
  helper 'spree/base', 'spree/store'

  if Spree::Auth::Engine.dash_available?
    helper 'spree/analytics'
  end

  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::Common
  include Spree::Core::ControllerHelpers::Order
  include Spree::Core::ControllerHelpers::SSL

  ssl_required

  # Devise::PasswordsController allows for blank passwords.
  # Silly Devise::PasswordsController!
  # Fixes spree/spree#2190.
  def update
    if params[:spree_user][:password].blank?
      self.resource = resource_class.new
      resource.reset_password_token = params[:spree_user][:reset_password_token]
      set_flash_message(:error, :cannot_be_blank)
      render :edit
    else
      super
    end
  end

end
