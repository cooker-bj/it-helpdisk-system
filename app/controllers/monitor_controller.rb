class MonitorController < ApplicationController
  before_filter :login_required,:has_right?
  def index
    @it_cases=ItCase.monitor
    respond_to do |format|
    format.html
    format.json {render json: @it_cases}
    end


  end

  def list_not_taken_cases
    @it_cases= ItCase.unchecked_cases
  end

   def list_more_hours_cases

     @it_cases= ItCase.unchecked_more_hours_cases
   end


    def list_working_cases
      @it_cases=ItCase.working_cases
    end

    def list_worked_more_days_cases
      @it_cases=ItCase.worked_more_than_days_cases
    end

    def list_today_closed_cases
      @it_cases=ItCase.today_closed_cases
    end
end
