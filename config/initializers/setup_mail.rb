#ActionMailer::Base.smtp_settings= {
# :address => "smtp.gmail.com",
# :port => 587,
# :domain =>"gmail.com",
# :user_name => "cooly.kang@gmail.com",
# :password => "legend8898",
# :authentication => "plain",
# :enable_starttls_auto =>true
#}

ActionMailer::Base.smtp_settings=YAML.load_file("#{Rails.root}/config/mail.yml")
