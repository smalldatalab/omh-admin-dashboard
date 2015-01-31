class ApplicationMailer < ActiveMailer::Base 
  default "from@gmail.com"
  layout 'mailer'
end 