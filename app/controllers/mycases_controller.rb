#--encoding: UTF-8 --
class MycasesController < ApplicationController
  before_filter :login_required
  def index
        @my_opened_cases=ItCase.where( :user_id=>current_user.id,:status=>[ItCase::STATUSES['Waiting'], ItCase::STATUSES['Working']]) .order("opened_time ")
        @my_closed_cases=ItCase.where(:user_id=>current_user.id,:status=>ItCase::STATUSES['Closed']).limit(10)
        respond_to do |format|
          format.html # index.html.erb
          format.json { render json: @it_cases }
        end
  end

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
    respond_to do |format| 
    if(@it_case.user_id==current_user.id)
      format.html
    else
     format.html{ redirect_to mycases_path, notice:"无权对它人工单评价"}
   end 
   end
     
  end



  # POST /it_cases
  # POST /it_cases.json
  def create
    @it_case = ItCase.new(params[:it_case])
    @it_case.user_id=current_user.id
    @it_case.ipaddress=request.remote_ip
    @it_case.status=ItCase::STATUSES['Waiting']
    @it_case.opened_time=Time.now
    @it_case.created_type='web'
    @it_case.creator_id=current_user.id
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
        format.html { redirect_to mycases_path, notice: '已完成评价' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @it_case.errors, status: :unprocessable_entity }
      end
    end
  end



  def closed_cases
      @my_closed_cases=ItCase.where(:user_id =>current_user.id,:status=>ItCase::STATUSES['Closed']).paginate(:page=>params[:page],:per_page=>60)
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @it_cases }
      end
    end
end
