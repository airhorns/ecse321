# ProjectCostsController manages the {ProjectCost} objects by providing a RESTful HTML interface. 
# @author Shen Chen Xu
class ProjectCostsController < ApplicationController
  # GET /project_costs
  # GET /project_costs.xml
  def index
    @project_costs = ProjectCost.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @project_costs }
    end
  end

  # GET /project_costs/1
  # GET /project_costs/1.xml
  # def show
  #   @project_cost = ProjectCost.find(params[:id])

  #   respond_to do |format|
  #     format.html # show.html.erb
  #     format.xml  { render :xml => @project_cost }
  #   end
  # end

  # GET /project_costs/new
  # GET /project_costs/new.xml
  # def new
  #   @project_cost = ProjectCost.new

  #   respond_to do |format|
  #     format.html # new.html.erb
  #     format.xml  { render :xml => @project_cost }
  #   end
  # end

  # GET /project_costs/1/edit
  # def edit
  #   @project_cost = ProjectCost.find(params[:id])
  # end

  # POST /project_costs
  # POST /project_costs.xml
  # def create
  #   @project_cost = ProjectCost.new(params[:project_cost])

  #   respond_to do |format|
  #     if @project_cost.save
  #       flash[:notice] = 'ProjectCost was successfully created.'
  #       format.html { redirect_to(@project_cost) }
  #       format.xml  { render :xml => @project_cost, :status => :created, :location => @project_cost }
  #     else
  #       format.html { render :action => "new" }
  #       format.xml  { render :xml => @project_cost.errors, :status => :unprocessable_entity }
  #     end
  #   end
  # end

  # # PUT /project_costs/1
  # # PUT /project_costs/1.xml
  # def update
  #   @project_cost = ProjectCost.find(params[:id])

  #   respond_to do |format|
  #     if @project_cost.update_attributes(params[:project_cost])
  #       flash[:notice] = 'ProjectCost was successfully updated.'
  #       format.html { redirect_to(@project_cost) }
  #       format.xml  { head :ok }
  #     else
  #       format.html { render :action => "edit" }
  #       format.xml  { render :xml => @project_cost.errors, :status => :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /project_costs/1
  # DELETE /project_costs/1.xml
  # def destroy
  #   @project_cost = ProjectCost.find(params[:id])
  #   @project_cost.destroy

  #   respond_to do |format|
  #     format.html { redirect_to(project_costs_url) }
  #     format.xml  { head :ok }
  #   end
  # end
end
