#--*- encoding: UTF-8
class ClosedNotice < ActionMailer::Base
  default from: "ithelp@autonavi.com"

  def closed_notice(user,itcase)
    @recipient=user.name
    @itcase=itcase
    mail(
      :to => user.email,
      :subject =>"IT Cases closed notication" 
    )
  end
end
