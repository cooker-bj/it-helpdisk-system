class UpdateNotice < ActionMailer::Base
  default from: "ithelp@autonavi.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.update_notice.update_notice.subject
  #
  def update_notice(receiver)
    @receiver =receiver

    mail(
          :to => @receiver.email,
          :subject =>"It Cases Update Notification"
    )
  end
end
