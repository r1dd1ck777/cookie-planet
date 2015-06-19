my = {
    :address              => 'mail.bbon.com.ua',
    :port                 => 250,
    :domain               => Settings.host,
    :user_name            => 'robot@bbon.com.ua',
    :password             => 'Teccvlvy7',
    :authentication       => 'plain',
    :enable_starttls_auto => false,
}

ActionMailer::Base.smtp_settings = my

ActionMailer::Base.default_url_options[:host] = Settings.host
ActionMailer::Base.default :charset => "utf-8"
ActionMailer::Base.default :from => "robot@korma.in.ua"
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true
