# frozen_string_literal: true

Spree::Admin::BaseController.class_eval do
  def unauthorized
    if try_spree_current_user
      flash[:error] = Spree.t(:authorization_failure)
      redirect_to spree.admin_unauthorized_path
    else
      store_location
      redirect_to spree.admin_login_path
    end
  end

  protected

    def model_class
      const_name = controller_name.classify
      if Spree.const_defined?(const_name, false)
        return "Spree::#{const_name}".constantize
      end
      nil
    end
end
