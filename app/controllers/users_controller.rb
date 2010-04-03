# The +UsersController+ is responsible for registering (creating) new {User} records and managing them.
# @author Harry Brundage
class UsersController < ApplicationController
  include Canable::Enforcers
  # Make sure the user manging new users is logged in
  before_filter :require_user
  
  # Renders the registration form for a new user
  # Route: GET /users/new
  def new
    @user = User.new
    enforce_create_permission(@user)
  end
  
  # Accepts HTML POST data from the {UsersController#new} action to create a new +User+ record.
  # Route: POST /users
  def create
    @user = User.new(params[:user])
    enforce_create_permission(@user)
    if @user.save
      flash[:notice] = "Account registered!"
      redirect_back_or_default account_url
    else
      render :action => :new
    end
  end
  
  # Shows a particular user's details
  # Route: GET /users/1
  def show
    @user = @current_user
    enforce_view_permission(@user)
    
  end
  
  # Renders the form to edit a particular user
  # Route: GET /users/1/edit
  def edit
    @user = @current_user
    enforce_update_permission(@user)
  end
  
  # Accepts data from the {UsersController#edit} form to update the attributes
  # of an existing +User+ record
  # Route: PUT /users/1
  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    enforce_update_permission(@user)
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end
end