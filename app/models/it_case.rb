#-- encoding: UTF-8 --
class ItCase < ActiveRecord::Base
  has_many :tasks
  validates_presence_of :name,:message=>"姓名不能为空"
  validates_presence_of :cubnum,:message=>"工位编号不能为空"
  validates_presence_of :description,:message=>'故障描述不能为空'
  validates_presence_of :phone, :message=>'电话不能为空'
  validates_presence_of :department,:message=>"部门不能为空"
  validates_format_of :email, :with=>/\A([^@\s]+)@([?:[-a-z0-9]+\.]+[a-z]{2,})\Z/i,:message=>'email地址格式错误'
  validates_format_of :phone, :with=>/\A[0-9]+\Z/, :message=>'电话格式错误'
  LOCATIONS=['昌平','大恒','方恒',"宝能","大地",'其它']
  CASETYPES=['网络故障','网络布线','安装系统','入库检测','软件故障','服务器','电话或邮件','硬件故障','其它']
  STATUSES={'Waiting'=>'待处理','Working'=>'处理中','Closed'=>'已完成'}


  def self.get_cases_number(mystatus)
    num=Hash.new
    res=self.where(:status=>mystatus)
    LOCATIONS.each do |li|
      num[li]=res.where(:location=>li).length
    end

       num
  end




  def self.monitor
  it_cases=Hash.new
  it_cases[:today]=today
  it_cases[:cases]=ItCase.where("date(opened_time)=:date",:date=> it_cases[:today]).length

  waiting_cases=ItCase.where(:status=>ItCase::STATUSES['Waiting'])
  it_cases[:waiting]=waiting_cases.length
  working_cases=ItCase.where(:status=>ItCase::STATUSES['Working'])
  it_cases[:working]=working_cases.length
  it_cases[:closed]=ItCase.where("status=:status and date(closed_time)=:date",:status => ItCase::STATUSES['Closed'],:date=> it_cases[:today]).length
  it_cases[:waiting_more_than_hours]=waiting_cases.where("opened_time<:time",:time=>(Time.now-3600)).length
  it_cases[:working_cases_more_than_one_day]=working_cases.where("opened_time<:time",:time=>(Time.now-3600*24)).length
  it_cases
  end

  def self.unchecked_cases
         self.where(:status=>ItCase::STATUSES['Waiting'])
  end

  def self.unchecked_more_hours_cases
    self.where("status=:status and opened_time<:time",:status=>ItCase::STATUSES['Waiting'],:time=>(Time.now-3600))
  end

  def self.working_cases
    self.where(:status=>ItCase::STATUSES['Working'])
  end


  def self.worked_more_than_days_cases
    self.where("opened_time<:time and status=:status",:time=>(Time.now-3600*24),:status=>ItCase::STATUSES['Working'])
  end

  def self.today_closed_cases
    self.where("status=:status and date(closed_time)=:date",:status => ItCase::STATUSES['Closed'],:date=> today)
  end


  def self.weekly_case_number(day)
    mycases=Hash.new
    (0..6).each do |n|
     mycases["#{(day-(6-n).days).strftime("%a")}"]=self.where("date(opened_time)=:date",:date=>format_day(day-(6-n).days)).size
    end
    mycases
  end

  def self.monthly_case_number(day)
    mycases=Hash.new
    (0..11).each do |n|
      cur=day-(11-n).months
      mycases["#{cur.strftime("%b")}"]=self.where("year(opened_time)=:year and month(opened_time)=:month",:year=>cur.strftime("%Y"),:month=>cur.strftime("%-m")).count()
    end
    mycases
  end



  def self.summary_by_type(first, last)
    self.select("casetype").where("date(opened_time)>=:start and date(opened_time)<=:end",:start=>format_day(first),:end=>format_day(last)).group("casetype").count()

  end


   def self.summary_average_waitting_by_zone(first,last)
     mycases=Hash.new
     ItCase::LOCATIONS.each do |location|
     mycases[location]=self.where("date(opened_time)>=:start and date(opened_time)<=:end and location=:location and ( status=:status1 or status=:status2)",:start=>format_day(first),:end=>format_day(last),:status1=> ItCase::STATUSES['Closed'],:status2=> ItCase::STATUSES['Working'],:location=>location).average('round((begin_time-opened_time)/60,1)')
     mycases[location]=mycases[location].nil? ? 0 : mycases[location]
     end
     mycases
   end

    def self.summary_average_workon_by_type(first,last)
      self.select("casetype").where("status=:st and date(opened_time)>=:start and date(opened_time)<=:end",:st=>ItCase::STATUSES['Closed'],:start=>format_day(first),:end=>format_day(last)).group("casetype").average("round((closed_time-begin_time)/60,1)")
    end


    def self.summary_by_rank(first,last)
      self.select("rank").where("date(opened_time)>=:start and date(opened_time)<=:end",:start=>format_day(first),:end=>format_day(last)).group("rank").count('*')
    end

    def self.summary_rank_by_staff(first,last)
      self.joins(:tasks).select("tasks.name,rank,opened_time").where("date(opened_time)>=:start and date(opened_time)<=:end and rank is not null",:start=>format_day(first),:end=>format_day(last)).group("tasks.name").average("rank")
    end

    def self.summary_callin_type(first,last)
        self.select('created_type').where("date(opened_time)>=:start and date(opened_time)<=:end",:start=>format_day(first),:end=>format_day(last)).group("created_type").count('*')

    end
private

  def  self.today
    Time.now.strftime("%Y-%m-%d")
  end

   def self.format_day(day)
     day.strftime("%Y-%m-%d")
   end
end
