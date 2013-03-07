#encoding: UTF-8
namespace :email_tasks do
  desc "get tasks from email"
  task :get_tasks =>:environment do 
#    require 'app/models/it_case'
 #   require 'app/models/task'
  #  require 'app/models/user'
    require 'kconv'
    require 'viewpoint'
    def clear_text(str)
      patten=/<!--.*-->/m

      str.gsub(patten,'')
    end
    Viewpoint::EWS::EWS.endpoint="https://mail.autonavi.com/ews/Exchange.asmx"
    Viewpoint::EWS::EWS.set_auth 'autonavi\helpdesk','legend*898'
    inbox=Viewpoint::EWS::Folder.get_folder_by_name("Inbox")
    read=Viewpoint::EWS::Folder.get_folder_by_name('read')
    match_str=/^[re|回复]:/i
	begin

	items=inbox.find_items
	items.each do |item|
        email=item.to_mail
        receivers=email.to
        sender=email.from.first
        subject=email.subject

        unless subject=~match_str ||  (user=User.find_by_mail(sender)).nil?

          receivers.each do |receiver|

            worker=User.find_by_mail(receiver)
            if !worker.nil? && Management.has_rights("mytasks",worker.id)


              thiscase=ItCase.new
              thiscase.user_id=user.id
              thiscase.name=user.name
              thiscase.department=user.department
              thiscase.email=user.email
              thiscase.description= case email.multipart?
                                   when true then email.text_part.body.empty? ? email.html_part.body : clear_text(email.text_part.body.to_s)
                                   else
                                     email.body
                                 end
              thiscase.casetype="其它"
              thiscase.status=ItCase::STATUSES["Working"]
              thiscase.opened_time=Time.now
              thiscase.created_type="email"
              thiscase.begin_time=Time.now
              thiscase.phone="84107000"
              thiscase.cubnum="unknow"
              thiscase.location="其它"
              thistask=Task.new
              thistask. userid=worker.id
              thistask.taken_date=Time.now
              thistask.status="pending"
              thistask.name=worker.name

                p thiscase.description
              ItCase.transaction do
                thiscase.save
                thiscase.tasks<<thistask
              end
                 break
            end
          end
         
        end
       item.move!(read)
        end
  rescue =>msg
    p "execption=#{msg}"
    ActiveRecord::Base.logger.info("email add user error:#{msg}")
   end
  end
end
