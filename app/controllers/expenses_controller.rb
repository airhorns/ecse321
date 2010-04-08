# ExpensesController manages the {Expense} objects by providing a RESTful HTML interface. 
# @author Shen Chen Xu
class ExpensesController < ApplicationController
  before_filter :require_user
  
  # GET /expenses
  # GET /expenses.xml
  def index
    state_condition = [Expense::Pending, Expense::Rejected]
    if params[:all]
      state_condition = false
    else
      if params[:pending]
        state_condition = Expense::Pending
      elsif params[:rejected]
        state_condition = Expense::Rejected
      end
      @expense = Expense.new
    end
    conditions = {:user_id => current_user.id}
    conditions[:state] = state_condition if state_condition
    @expenses = Expense.find(:all, :order => "date DESC", :conditions => conditions)
  
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @expenses }
    end
  end

  # GET /expenses/1
  # GET /expenses/1.xml
  def show
    @expense = Expense.find(params[:id])
    enforce_view_permission(@expense)
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @expense }
    end
  end

  # GET /expenses/new
  # GET /expenses/new.xml
  def new
    @expense = Expense.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @expense }
    end
  end

  # GET /expenses/1/edit
  def edit
    @expense = Expense.find(params[:id])
    enforce_update_permission(@expense)
  end

  # POST /expenses
  # POST /expenses.xml
  def create
    @expense = Expense.new(params[:expense])
    @expense.state = Expense::Pending
    @expense.user_id = current_user.id
    enforce_create_permission(@expense)
    
    respond_to do |format|
      if @expense.save
        flash[:notice] = 'Expense was successfully created.'
        format.html { redirect_to(@expense) }
        format.xml  { render :xml => @expense, :status => :created, :location => @expense }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @expense.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /expenses/1
  # PUT /expenses/1.xml
  def update
    @expense = Expense.find(params[:id])
		@expense.state = Expense::Pending
    enforce_update_permission(@expense)
    enforce_save_permission(@expense)
    
    respond_to do |format|
      if @expense.update_attributes(params[:expense])
        flash[:notice] = 'Expense was successfully updated.'
        format.html { redirect_to(@expense) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @expense.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /expenses/1
  # DELETE /expenses/1.xml
  def destroy
    @expense = Expense.find(params[:id])
    enforce_destroy_permission(@expense)
    
    @expense.destroy

    respond_to do |format|
      format.html { redirect_to(expenses_url) }
      format.xml  { head :ok }
    end
  end


  def approve
    @expense = Expense.find(params[:id])
    enforce_approve_permission(@expense)
		@expense.state = Expense::Approved

    respond_to do |format|
      if @expense.update_attributes(params[:expense])
        flash[:notice] = 'Expense was successfully approved.'
        format.html { redirect_to(:back) }
        # format.html { redirect_to(@expense) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @expense.errors, :status => :unprocessable_entity }
      end
    end
	end

  def reject
    @expense = Expense.find(params[:id])
    enforce_reject_permission(@expense)
		@expense.state = Expense::Rejected

    respond_to do |format|
      if @expense.update_attributes(params[:expense])
        flash[:notice] = 'Expense was successfully rejected.'
        format.html { redirect_to(:back) }
        # format.html { redirect_to(@expense) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @expense.errors, :status => :unprocessable_entity }
      end
    end
	end
end
