# The +UserSessionsController+ manages the {UserSession} objects which represent an 
# instance of a authenticated user's interaction with the system. +UserSession+s are 
# created by AuthLogic only when authorized, hooking into the +UserSession#save+ 
# callback chain method to validate the submitted user's details. This controller
# is responsible for rendering the forms and preforming the redirects when a user 
# logs in or is denied access.
# @author Harry Brundage
class UserSessionsController < ApplicationController
  
  # Ensure a user isn't logged in already when they try to log in.
  before_filter :require_no_user, :only => [:new, :create]
  # Ensure a user is logged in when they try and log out
  before_filter :require_user, :only => :destroy
  
  # Render the login form (to create a new +UserSession+)
  # Route: GET /user_sessions/new
  def new
    @user_session = UserSession.new
  end
  
  # Accepts POST data from the login form to validate and create a new +UserSession+ record
  # Route: GET /user_sessions/new
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      # Call the special redirect handler {ApplicationController#redirect_back_or_default} 
      # to take a user back to the url they tried to access but were denied access.
      redirect_back_or_default account_url 
    else
      # Show the user the login form again if they weren't able to log in.
      render :action => :new
    end
  end
  
  # Destroy the current user's +UserSession+ to log them out
  # Route: DELETE /user_sessions/1
  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default new_user_session_url
  end
end