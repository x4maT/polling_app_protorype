class SurveyMailer < ApplicationMailer
  default from: 'hello@domain.com'
  
  def added_survey(user,survey)
    @user=user
    @survey = survey
    mail(to: @user.email,subject: 'your survey is successfully created')
  end

   # def updated_survey(user,survey)
   #   @user=user
   #   @survey = survey
   #   mail(to: @user.email,subject: 'your survey is successfully Updated')

   # end
end