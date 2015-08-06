module Spree
  class UserMailer < BaseMailer
    def reset_password_instructions(user, token, *args)
      if Spree::Config.site_url
        @edit_password_reset_url = spree.edit_spree_user_password_url(:reset_password_token => token, :host => Spree::Config.site_url)

        mail(:to => user.email, :from => from_address,
             :subject => Spree::Config[:site_name] + ' ' +
                 I18n.t(:subject, :scope => [:devise, :mailer, :reset_password_instructions]))
      end
    end

    def confirmation_instructions(user, token, opts={})
      #hack so that confirmable module is still used after first confirmation
      Spree::Auth::Config[:confirmable] = true
      if Spree::Config.site_url
        @user = user
        @confirmation_url = spree.spree_user_confirmation_url(:confirmation_token => token, :host => Spree::Config.site_url)
        @email = @user.pending_reconfirmation? ? @user.unconfirmed_email : @user.email

        mail to: @email, from: from_address,
             subject: Spree::Config.site_name + ' ' +
                 I18n.t(:subject, :scope => [:devise, :mailer, :confirmation_instructions])
      end
    end
  end
end
