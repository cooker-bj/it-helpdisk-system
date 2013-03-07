#--*- encoding: UTF-8
class Management < ActiveRecord::Base
  has_many :rights
  before_validation(:on=>:create)  {get_userid }
#  validates_with LdapValidator, :attr=>:user
  validates_presence_of :userid,:user
  validates_uniqueness_of :userid

  CONTROLLER={"monitor"=>'监控',"mytasks"=>"处理工单","managements"=>"人员管理","callcenters"=>"电话工单","summary"=>"业务报表","query"=>'查询'}



  def myrights
    n={}
    unless self.rights.empty?
      self.rights.each  {|key| n[key.name]='on' }

      end
     n
  end

  def myrights=(list)
    unless self.rights.nil?
      self.rights.each do |item|
        self.rights.delete(item) unless list.has_key?(item.name)
       #logger.info "yes I got it"
      end

    end
    unless list.empty?
      list.each do |key, value|
          unless self.rights.index(key)
            myright=Right.new
            myright.name=key
            self.rights<<myright
          end

      end
    end


  end



   def self.has_rights(c_name, userid)

    my=self.where(:userid=>userid).first
   if my.nil?
        nil
    else
      my.rights.index{|x|x.name==c_name}
    end


  end

  private
  def get_userid()
    my=User.find_by_mail(self.email)
    self.userid=my.id unless my.nil?
  end

end
