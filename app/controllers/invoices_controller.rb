class InvoicesController < ApplicationController
  before_filter :require_user
  
  # Search for all Expense objects in the database that are associated with the invoice's
  # project and with `date' attribute between the `start_date' and `end_date' attributes of the invoice
  def list_expenses
    #age = params[:age]
	#person = Person.find(:all, :conditions => "name = '#{name}' and age = '#{age}'")
    #@all_expenses = Expense.all
	
	respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @invoices }
    end
  
  end
  
  
  # GET /invoices
  # GET /invoices.xml
  def index
    #@invoices = Invoice.find(:all, :conditions => {:project => "Superman", :client => "Robot"})
	@invoices = Invoice.find(:all)
	#@all_expenses = Expense.find(:all)
	
	start_date = '2010-03-31'
	end_date = '2018-03-31'
	@all_expenses = Expense.find(:all, :conditions => {:date => start_date..end_date})
	@all_tasks = Task.all
	

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @invoices }
    end
  end

  # GET /invoices/1
  # GET /invoices/1.xml
  def show
    @invoice = Invoice.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @invoice }
    end
  end

  # GET /invoices/new
  # GET /invoices/new.xml
  def new
    @invoice = Invoice.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @invoice }
    end
  end

  # GET /invoices/1/edit
  def edit
    @invoice = Invoice.find(params[:id])
  end

  # POST /invoices
  # POST /invoices.xml
  def create
    @invoice = Invoice.new(params[:invoice])

    respond_to do |format|
      if @invoice.save
        flash[:notice] = 'Invoice was successfully created.'
        format.html { redirect_to(@invoice) }
        format.xml  { render :xml => @invoice, :status => :created, :location => @invoice }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @invoice.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /invoices/1
  # PUT /invoices/1.xml
  def update
    @invoice = Invoice.find(params[:id])

    respond_to do |format|
      if @invoice.update_attributes(params[:invoice])
        flash[:notice] = 'Invoice was successfully updated.'
        format.html { redirect_to(@invoice) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @invoice.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.xml
  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.destroy

    respond_to do |format|
      format.html { redirect_to(invoices_url) }
      format.xml  { head :ok }
    end
  end
end
