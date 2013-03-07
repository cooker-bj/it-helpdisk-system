class Upgrade < ActiveRecord::Base
  belongs_to :sender, :class_name=>'Task', :foreign_key =>'sender_id'
  belongs_to :receiver, :class_name=>'Task',:foreign_key=>'receiver_id'
end
