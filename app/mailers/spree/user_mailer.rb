module Spree
  class UserMailer < BaseMailer
    def reset_password_instructions(user, token, *args)
      @edit_password_reset_url = spree.edit_spree_user_password_url(:reset_password_token => token, :host => Spree::Config.site_url)

      mail(:to => user.email, :from => from_address,
          :subject => Spree::Config[:site_name] + ' ' +
            I18n.t(:subject, :scope => [:devise, :mailer, :reset_password_instructions]))
    end

    def confirmation_instructions(user, token, opts={})
      #hack so that confirmable module is still used after first confirmation
      Spree::Auth::Config[:confirmable] = true
      @user = user
      host = Spree::Config.site_url.present? ? Spree::Config.site_url : "no_site_url"
      @confirmation_url = spree.spree_user_confirmation_url(:confirmation_token => token, :host => host)
      @email = @user.pending_reconfirmation? ? @user.unconfirmed_email : @user.email
      mail to: @email, from: from_address, subject: Spree::Config.site_name + ' ' + I18n.t(:subject, :scope => [:devise, :mailer, :confirmation_instructions])
    end
  end
end
