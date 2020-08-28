# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@bayan-photo-contest.com'
  layout 'mailer'
end
