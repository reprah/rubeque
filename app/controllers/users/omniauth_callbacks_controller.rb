class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def twitter
    sign_in_or_register(:twitter)
  end

  def github
    sign_in_or_register(:github)
  end

  def google
    @user = User.find_for_open_id(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.google_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  private

    def sign_in_or_register(provider)
      puts 'sign in or register logging'
      if !User.omniauth_providers.index(provider).nil?
        omniauth = env["omniauth.auth"]
        puts 'getting omniauth'
        if current_user
          puts 'getting current user'
          current_user.user_tokens.find_or_create_by provider: uomniauth['provider'], id: omniauth['uid']
           flash[:notice] = "Authentication successful"
           redirect_to edit_user_registration_path
        else
          puts 'no current user, getting user token'
          user_token = UserToken.where(provider: omniauth['provider'], uid: omniauth['uid']).first
          puts omniauth['uid']
          if user_token
            puts 'has user token'
            flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => omniauth['provider']
            sign_in_and_redirect(:user, user_token.user)
          else
            puts 'creating new user'
            user = User.new
            user.apply_omniauth(omniauth)
            if user.save
              puts 'user saved'
              flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => omniauth['provider'] 
              sign_in_and_redirect(:user, user)
            else
              session[:omniauth] = omniauth.except('extra')
              flash[:error] = "Could not create new user account: #{user.errors.first.join(" ")}"
              redirect_to new_user_registration_url
            end
          end
        end
      end
    end

end
