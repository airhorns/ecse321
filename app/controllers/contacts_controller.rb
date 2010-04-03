class ContactsController < ApplicationController
  # GET /contacts
  def index
    @contacts = Contact.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /contacts/1
  def show
    @contact = Contact.find(params[:id])
    enforce_view_permission(@contact)

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /contacts/new
  def new
    @contact = Contact.new
    @contact.address = Address.new
    enforce_create_permission(@contact)
    
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /contacts/1/edit
  def edit
    @contact = Contact.find(params[:id])
    enforce_update_permission(@contact)
    
  end

  # POST /contacts
  def create
    @contact = Contact.new(params[:contact])
    enforce_create_permission(@contact)

    respond_to do |format|
      if @contact.save
        flash[:notice] = 'Contact was successfully created.'
        format.html { redirect_to(@contact) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /contacts/1
  def update
    @contact = Contact.find(params[:id])
    enforce_update_permission(@contact)

    respond_to do |format|
      if @contact.update_attributes(params[:contact])
        flash[:notice] = 'Contact was successfully updated.'
        format.html { redirect_to(@contact) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /contacts/1
  def destroy
    @contact = Contact.find(params[:id])
    enforce_destroy_permission(@contact)
    
    @contact.destroy

    respond_to do |format|
      format.html { redirect_to(contacts_url) }
    end
  end
end
