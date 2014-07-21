# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
CmsApp::Application.initialize!


ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
    :address        => 'smtp.gmail.com',
    :domain         => 'mail.google.com',
    :port           => 587,
    :user_name      => 'amiteshmaheshwari@gmail.com',
    :password       => 'csciitkanpur',
    :authentication => :plain,
  	:enable_starttls_auto => true
}
ActionMailer::Base.default :content_type => "text/html"