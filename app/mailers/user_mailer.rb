class UserMailer < ActionMailer::Base
  default from: "notifications@example.com"

  def consent_email(user)
    @user = user
    @url = 'http://example.com/login'
    email_with_name = %("#{@user.first_name}" <#{@user.gmail}>) 

    # user.studies.all.map do |a|
    mail(to: email_with_name,
      subject: 'Welcome to Small Data Workshop!', template_path: 'user_mailer') do |format| 
        format.html {render 'consent_email'}
        format.text {render 'consent_email'}
      end
    end 
  end 
end
   
