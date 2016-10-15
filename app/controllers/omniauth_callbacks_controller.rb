class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
  end

  def twitter
  end

  def auth
    @user = User.find_for_oauth(request.env["omniauth.auth"])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: auth.provider.capitalize) if is_navigational_format?
    else
      sign_in_and_redirect @user, event: :authentication
      flash[:success] = "Signed in successfully via #{ auth['provider'].capitalize }." 
      flash[:notice] = "A message with a confirmation link has been sent to your email address. Please follow the link to activate your account." 
    end  
    end
  end
end