#--*- encoding: UTF-8
class CallcentersController < ApplicationController
  before_filter :login_required,:has_right?
  def index
    @it_cases = ItCase.where("creator_id=:uid and date(opened_time)=:opened and created_type='phone'",:uid=>current_user.id,:opened=>Time.now.strftime("%Y-%m-%d"))

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @it_cases }
    end
  end

  def new
    @it_case = ItCase.new

  end


    def create
      @it_case = ItCase.new(params[:it_case])
      @it_case.user_id=User.find_by_mail(@it_case.email)
      @it_case.status=ItCase::STATUSES['Waiting']
      @it_case.opened_time=Time.now
      @it_case.creator_id=current_user.id
      @it_case.created_type="phone"
      @it_case.email<<"@autonavi.com"
      respond_to do |format|
        if @it_case.save
          format.html { redirect_to url_for(:action=>'index'), notice: '工单已建立' }
        else
          format.html { render action: "new" }
        end
      end
    end



  def get_user
    email=params[:email]
    email<<"@autonavi.com"
    @it_case=ItCase.new
     respond_to do |format|
      unless (user=User.find_by_mail(email) ).nil?
        @it_case.name=user.name
        @it_case.department=user.department
        @it_case.email=user.email
      
       format.json{  render json: @it_case}

      else

        format.json{render json: @it_case.errors, status: :unprocessable_entity}
       end

      end



  end
end
