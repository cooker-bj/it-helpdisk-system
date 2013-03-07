#--*-- encoding: UTF-8 --*-
class Task < ActiveRecord::Base
  belongs_to :it_case
  has_many :upgrades


  # @param userid [Object]

 def self.new_pending(userid)
     mytask=self.new
     mytask.userid=userid
     mytask.name=User.find_by_id(userid).name
     mytask.taken_date=Time.now
     mytask.status='pending'
     mytask

 end

  def self.find_tasks_by_id_and_status(userid,mystatus)

    self.where('userid=:id and it_cases.status=:status',:id=>userid,:status=>mystatus).includes(:it_case)

  end


  def self.summary_by_staff(first,last)
    result=Hash.new
    p=self.where("finished_time>:start and finished_time<:last",:start=>first,:last=>last)
    result[:total]=p.group("userid,name").count()
    result[:upgrade]=p.where(:status=>'upgraded').group("userid,name").count()
    result

  end

  def self.summary_average_workon_by_staff(first,last)
    self.where("finished_time>:start and finished_time<:last",:start=>first,:last=>last).group("userid,name").average("round((finished_time-taken_date)/60,1)")
  end



end
