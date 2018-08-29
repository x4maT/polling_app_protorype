class UserMailer < ApplicationMailer
	default from: "Hello<hello@domain.com>"

	def new_answer(answer)
    	@answer = answer
    	@question = @answer.question
    	@user=@question.user
    	mail(to: @user.email,subject: "New answer for #{@question.title}")
  	end

  	def welcome_email
    	@user = params[:user]
      mail(to: @user.email, subject: 'Welcome to IdeaScreener.com')
  	end
end