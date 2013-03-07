#-- encoding: UTF-8
class MytasksController < ApplicationController
  before_filter :login_required,:has_right?
  def index
    #@waiting_tasks=ItCase.where(:status=>ItCase::STATUSES['Waiting']) .order("opened_time")
    @waiting_lines=ItCase.get_cases_number(ItCase::STATUSES['Waiting'])
    @working_tasks=Task.where(:userid=> current_user.id,:status=>'pending')
    @closed_tasks=Task.where(:userid=> current_user.id,:status=>['closed','upgraded']).limit(10)
    respond_to do |format|
      format.html # show.html.erb

    end
  end



  def new
    @it_case=ItCase.where(:status=> ItCase::STATUSES['Waiting'],:location=>params[:location]).first
    unless @it_case.blank?
      @mytask=Task.new_pending(@current_user.id)
      @mytask.name=@current_user.name
      ItCase.transaction do
      @it_case.status=ItCase::STATUSES['Working']
      @it_case.begin_time=Time.now
      @it_case.save
      @it_case.tasks << @mytask
      end
    else
      flash[:notice]='该办公区无待处理工单'
      redirect_to '/mytasks'
    end
  end


  def edit
    @mytask=Task.find(params[:id])
    @it_case=@mytask.it_case
    respond_to do |format|
      format.html # show.html.erb

    end
  end



  def show
    @task = Task.find(params[:id])
     @it_case=@task.it_case
    respond_to do |format|
      format.html # show.html.erb

    end
  end

  def create
    @task = Task.new(params[:task])

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: '已建立任务.' }
        format.json { render json: @task, status: :created, location: @task }
      else
        format.html { render action: "new" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    @task = Task.find(params[:id])
    case
      when params[:key] then close_case(params)
      when params[:upgrade] then upgrade_case(params)
      else
        pending_case(params)
    end
    #if( params[:key])
    # @task.finished_time=Time.now
    #  @task.it_case.closer=@current_user.id
    #  @task.it_case.status=ItCase::STATUSES['已完成']
    #else
    #  @task.it_case.status=ItCase::STATUSES['处理中']
    #end

    #respond_to do |format|
    # if  @task.it_case.update_attributes(params[:it_case])
    #  format.html { redirect_to '/mytasks', notice: 'Task was successfully updated.' }

    #else
    # format.html { render action: "check_case" }

    #end
    #end
  end




  def close_case(myargs)
    task = Task.find(myargs[:id])
    task.finished_time=Time.now
    task.it_case.closer=@current_user.id
    task.it_case.status=ItCase::STATUSES['Closed']
    task.it_case.closed_time=Time.now
    task.status='closed'
    respond_to do |format|
      if  task.it_case.update_attributes(myargs[:it_case]) &&task.save
        user=User.find_by_id(task.it_case.user_id)
        message=ClosedNotice.closed_notice(user,task.it_case)
        message.deliver
        format.html { redirect_to '/mytasks', notice: '任务已完成.' }

      else
        format.html { render action: "check_case" }

      end
    end
  end


  def pending_case(myargs)
    task = Task.find(myargs[:id])
    task.it_case.status=ItCase::STATUSES['Working']
    task.status='pending'
    respond_to do |format|
      if  task.it_case.update_attributes(myargs[:it_case]) &&task.save
        format.html { redirect_to '/mytasks', notice: '任务正在等待处理.' }

      else
        format.html { render action: "check_case" }

      end
    end
  end



  def upgrade_case(myargs)
    @task= Task.find(myargs[:id])
    @task.it_case.status=ItCase::STATUSES['Working']
    respond_to do |format|
      if  @task.it_case.update_attributes(myargs[:it_case])
        format.html{render "upgrade"}

      else
        format.html { render action: "check_case" }

      end
    end

  end

  def upgrade
    receiver=params[:receiver]

    uper=Upgrade.new
    uper.reason=params[:reason]
    @task=Task.find(params[:id])
    @task.status="upgraded"
    @task.finished_time=Time.now
    user_case=@task.it_case
    respond_to do |format|
      if (receiver= User.find_by_id(receiver)) &&!uper.reason.blank?
        receiver_id=receiver.id
        receive_task=Task.new_pending(receiver_id)


        user_case.tasks<<receive_task
        @task.save
        receive_task.upgrades<<uper
        @task.upgrades<<uper
        message=UpdateNotice.update_notice(receiver)
        message.deliver
        format.html {redirect_to '/mytasks',notice:"工单已完成升级"  }
      else
        flash[:notice]="用户不存在或未说明升级原因"
        format.html {render action: 'upgrade'  }

      end
    end

  end

  def finished_tasks
    @mytasks=Task.where(:userid=>current_user.id,:status=>['closed','upgrade']).paginate(:page=>params[:page],:per_page=>60)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @mytasks }
    end
  end


  def verify_name
    name=params[:receiver]
    @result="正确的用户"
    if User.find_by_name(name).nil?
        @result="不存在的用户"
    end
    respond_to do |format|
      format.html {render :partial=>"verify_name"}
    end
  end
end
