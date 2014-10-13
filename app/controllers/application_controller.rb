class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user
  helper_method :user_signed_in?
  helper_method :correct_user?
  helper_method :user_complete?

  private
    def current_user
      begin
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
      rescue Exception => e
        nil
      end
    end

    def user_signed_in?
      return true if current_user
    end

    def correct_user?
      if controller_name == 'users'
        id = params[:id]
      else
        id = params[:user_id]
      end

      @user = User.find(id)
      unless current_user == @user
        redirect_to root_url, :alert => "Access denied."
      end
    end

    def user_complete?
      current_user && current_user.email.present?
    end

    def complete_user!
      redirect_to edit_user_path(current_user), alert: 'Please enter your email address.' if !user_complete?
    end

    def authenticate_user!
      if !current_user
        redirect_to root_path, :alert => 'Login please!'
      end
    end

end
