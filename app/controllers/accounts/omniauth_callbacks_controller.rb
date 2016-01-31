class Accounts::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    @account = Account.where_twitter(request.env["omniauth.auth"]).first_or_create

    if @account.persisted?
      sign_in_and_redirect @account, event: :authentication
    else
      session["devise.twitter_data"] = request.env["omniauth.auth"]
      redirect_to new_account_registration_url
    end
  end

  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  def after_omniauth_failure_path_for(scope)
    new_account_registration_url
  end
end
