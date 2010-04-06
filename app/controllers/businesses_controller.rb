# BusinessesController manages the {Business} objects by providing a RESTful HTML interface. 
# @author Harry Brundage
class BusinessesController < ApplicationController
  before_filter :require_user
  
  # Renders the index action, listing all the +Business+es. 
  # Route: GET /businesses
  def index
    @businesses = Business.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # Shows a particular +Business+
  # Route: GET /businesses/1
  def show
    @business = Business.find(params[:id])
    enforce_view_permission(@business)
    respond_to do |format|
      format.html # show.html.erb
      format.js { render :partial => 'details', :locals => {:business => @business}}
    end
  end

  # Renders the form to create a new +Business+.
  # Route: GET /businesses/new
  def new
    @business = Business.new
    @business.address ||= Address.new
    enforce_create_permission(@business)

    respond_to do |format|
      format.html # new.html.erb
    end
  end
  
  # Renders the formm to edit an exisitng +Business+
  # Route: GET /businesses/1/edit
  def edit
    @business = Business.find(params[:id])
    enforce_update_permission(@business)
    
  end

  # Accepts POST data from the {BusinessesController#new} form to validate and create a new +Business+ record
  # Route: POST /businesses
  def create
    @business = Business.new(params[:business])
    enforce_create_permission(@business)

    respond_to do |format|
      if @business.save
        flash[:notice] = 'Business was successfully created.'
        format.html { redirect_to(@business) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # Accepts POST data from the {BusinessesController#edit} form to validate and update the attributes 
  # of an existing +Business+ record
  # Route: PUT /businesses/1
  def update
    
    @business = Business.find(params[:id])
    enforce_create_permission(@business)
    
    respond_to do |format|
      if @business.update_attributes(params[:business])
        flash[:notice] = 'Business was successfully updated.'
        format.html { redirect_to(@business) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # Deletes an existing +Business+ object from the database
  # Route: DELETE /businesses/1
  def destroy
    @business = Business.find(params[:id])
    enforce_destroy_permission(@business)
    @business.destroy
    
    respond_to do |format|
      format.html { redirect_to(businesses_url) }
    end
  end
end
