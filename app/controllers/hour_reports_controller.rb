class HourReportsController < ApplicationController
  # GET /hour_reports
  # GET /hour_reports.xml
  def index
    @hour_reports = HourReport.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @hour_reports }
    end
  end

  # GET /hour_reports/1
  # GET /hour_reports/1.xml
  def show
    @hour_report = HourReport.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @hour_report }
    end
  end

  # GET /hour_reports/new
  # GET /hour_reports/new.xml
  def new
    @hour_report = HourReport.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @hour_report }
    end
  end

  # GET /hour_reports/1/edit
  def edit
    @hour_report = HourReport.find(params[:id])
  end

  # POST /hour_reports
  # POST /hour_reports.xml
  def create
    @hour_report = HourReport.new(params[:hour_report])
		@hour_report.state = 0		# initial state is 'Pending'

    respond_to do |format|
      if @hour_report.save
        flash[:notice] = 'HourReport was successfully created.'
        format.html { redirect_to(@hour_report) }
        format.xml  { render :xml => @hour_report, :status => :created, :location => @hour_report }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @hour_report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /hour_reports/1
  # PUT /hour_reports/1.xml
  def update
    @hour_report = HourReport.find(params[:id])
		@hour_report.state = 0		# reset state to 'Pending' after editing

    respond_to do |format|
      if @hour_report.update_attributes(params[:hour_report])
        flash[:notice] = 'HourReport was successfully updated.'
        format.html { redirect_to(@hour_report) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @hour_report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /hour_reports/1
  # DELETE /hour_reports/1.xml
  def destroy
    @hour_report = HourReport.find(params[:id])
    @hour_report.destroy

    respond_to do |format|
      format.html { redirect_to(hour_reports_url) }
      format.xml  { head :ok }
    end
  end

	def approve
    @hour_report = HourReport.find(params[:id])
		@hour_report.state = 1

    respond_to do |format|
      if @hour_report.update_attributes(params[:hour_report])
        flash[:notice] = 'HourReport was successfully approved.'
        format.html { redirect_to(@hour_report) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @hour_report.errors, :status => :unprocessable_entity }
      end
    end
	end
end
