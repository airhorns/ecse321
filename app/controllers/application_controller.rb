# Extended by all other controllers. Manages request forger protection, and provides methods to define authenitication requirements, 
# and to access the current user model. Filters added to this controller apply to all controllers in the application.  Likewise, all 
# the methods added will be available for all controllers. The application controller never serves any requests itself. 
# @author Harry Brundage

class ApplicationController < ActionController::Base
  include Canable::Enforcers
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  filter_parameter_logging :password # Scrub sensitive parameters from your log
  
  helper_method :current_user_session, :current_user

  rescue_from Canable::Transgression, :with => :permission_error
  
  private
  
    # Returns the current user's +UserSession+ if it exists. The session will only exist if a user has successfully logged in. 
    # @return [UserSession] the logged in user's session
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    # Returns the current user object if it exists. The current user will only exist if a user has successfully logged in. 
    # @return [User] the logged in user
    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end
    
    # This method ensures that the user viewing the page has logged in. Call this method
    # in a before_filter chain to prevent access to a particular action for users who haven't logged in.
    # @return [boolean] the result of the authentication check
    def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to new_user_session_url
        return false
      end
    end

    # This method ensures that the user viewing the page has not logged in. Call this method
    # in a before_filter chain to prevent access to a particular action by logged in users.
    # @return [boolean] the result of the authentication check
    def require_no_user
      if current_user
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to account_url
        return false
      end
    end

    # Stores the user's intended destination in the event they aren't able to read it due to lack of authorization or authentication.
    # @return [String] the user's intended destination URL 
    def store_location
      session[:return_to] = request.request_uri
    end
    
    # Redirects the user to their previously intended destination if it exists and to a default if not. Called after a user has successfully
    # logged in to send them back to where they were going if they were interrupted. 
    # @return [nil]
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
    
    def permission_error
      flash[:error] = "You do not have permission to access this page, please contact an administrator if you think is an error."
      redirect_to(root_url)
    end
end
