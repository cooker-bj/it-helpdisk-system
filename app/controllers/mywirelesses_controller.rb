#--*-- encoding: UTF-8
class MywirelessesController < ApplicationController

  before_filter :login_required
  def index
    @myapps= Applicate.where(:user_id=>current_user.id).order("enabled_time DESC").paginate(:page=>params[:page],:per_page=>20)
  end

  def new
    @myapp=Applicate.new
  end

  def create
    @myapp=Applicate.new(params[:applicate])
    @myapp.user_id=current_user.id
    @myapp.name=current_user.name
    @myapp.department=current_user.department
    @myapp.enabled_time=Time.local(params[:applicate]['enabled_time(1i)'],params[:applicate]['enabled_time(2i)'],params[:applicate]['enabled_time(3i)'],params[:applicate]['enabled_time(4i)'],params[:applicate]['enabled_time(5i)'])

    i=0
    disabled_time=@myapp.enabled_time+3600*@myapp.during
    while i<@myapp.number
       code=Wireless.new
     code.enabled_time=@myapp.enabled_time
      code.disabled_time=disabled_time
          code.account=SecureRandom.random_number(1000000)
          code.password=SecureRandom.base64(6)
       @myapp.wirelesses<<code
    i+=1
  end
    respond_to do |format|
    if  @myapp.save
          message=WirelessNotice.wireless_notice(current_user,@myapp)
          message.deliver
          format.html { redirect_to mywireless_path @myapp ,notice: "已完成申请"}
    else
          format.html { render action: 'new'}
    end


    end
  end


  def show
    @myapp=Applicate.find(params[:id])
  end

end
