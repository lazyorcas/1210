# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  helper :mail
  default from: "oscar.1210.social@gmail.com"
  layout "mailer"
end
