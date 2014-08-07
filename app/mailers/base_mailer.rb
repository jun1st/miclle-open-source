# coding: utf-8
class BaseMailer < ActionMailer::Base

  default :from => "no-reply@desksformac.com"

  default :charset => "utf-8"

  default :content_type => "text/html"

  default_url_options[:host] = "www.desksformac.com"

  layout 'mailer'

  # helper :topics, :users
end
