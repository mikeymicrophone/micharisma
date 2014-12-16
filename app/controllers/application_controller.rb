class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  def ensure_signup_complete
    # Ensure we don't go into an infinite loop
    return if action_name == 'finish_signup'

    # Redirect to the 'finish_signup' page if the futurist
    # email hasn't been verified yet
    if current_futurist && !current_futurist.email_verified?
      redirect_to finish_signup_path(current_futurist)
    end
  end
  
  def find_michael
    if current_futurist.andand.id == 1
      return true
    else
      redirect_to root_url
    end
  end
end
