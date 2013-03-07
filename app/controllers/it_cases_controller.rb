  # encoding: UTF-8

class ItCasesController < ApplicationController
  before_filter :login_required
  # GET /it_cases
  # GET /it_cases.json
  def index
    @it_cases = ItCase.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @it_cases }
    end
  end

  # GET /it_cases/1
  # GET /it_cases/1.json
  def show
    @it_case = ItCase.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @it_case }
    end
  end

  # GET /it_cases/new
  # GET /it_cases/new.json
  def new
    @it_case = ItCase.new

    @it_case.name=current_user.name
    @it_case.email=current_user.email
    @it_case.department=current_user.department
    @it_case.location= location_help



    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @it_case }
    end
  end

  # GET /it_cases/1/edit
  def edit_comment
    @it_case = ItCase.find(params[:id])
  end

  # POST /it_cases
  # POST /it_cases.json
  def create
    @it_case = ItCase.new(params[:it_case])
    @it_case.user_id=current_user.id
    @it_case.ipaddress=request.remote_ip
    @it_case.status=ItCase::STATUSES['Waiting']
    @it_case.opened_time=Time.now
    respond_to do |format|
      if @it_case.save
        format.html { redirect_to mycases_path, notice: '工单已建立' }

      else
        format.html { render action: "new" }

      end
    end
  end

  # PUT /it_cases/1
  # PUT /it_cases/1.json
  def update
    @it_case = ItCase.find(params[:id])

    respond_to do |format|
      if @it_case.update_attributes(params[:it_case])
        format.html { redirect_to mycases_path, notice: '工单已成功更新' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @it_case.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /it_cases/1
  # DELETE /it_cases/1.json
  def destroy
    @it_case = ItCase.find(params[:id])
    @it_case.destroy

    respond_to do |format|
      format.html { redirect_to it_cases_url }
      format.json { head :ok }
    end
  end
end
