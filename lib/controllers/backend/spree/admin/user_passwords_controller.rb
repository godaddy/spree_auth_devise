# frozen_string_literal: true

class Spree::Admin::UserPasswordsController < Devise::PasswordsController
  helper 'spree/base'

  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::Common
  include Spree::Core::ControllerHelpers::SSL

  helper 'spree/admin/navigation'
  helper 'spree/admin/tables'
  layout 'spree/layouts/admin'

  ssl_required

  def update
    if params[:spree_user][:password].blank?
      set_flash_message(:error, :cannot_be_blank)
      render :edit
    else
      super
    end
  end
end
