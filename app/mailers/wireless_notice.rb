#---*-- encoding: UTF-8
class WirelessNotice < ActionMailer::Base
  default from: "ithelp@autonavi.com"

  def wireless_notice(user,wireless)
    @recipient=user.name
    @wireless=wireless
    mail(
        :to => user.email,
        :subject =>"访客无线密码申请单"
    )
  end
end
