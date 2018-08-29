class UsersController < ApplicationController
skip_before_action :authenticate_request, only: %i[login register]

  def login
    authenticate params[:email], params[:password]
  end
  
  def test
    render json: {
          message: 'You have passed authentication and authorization test'
        }
  end

  def me
    render json: {
          user_id: current_user.id,
          email: current_user.email,
          created_at: current_user.created_at
        }
  end

  private

  def authenticate(email, password)
    command = AuthenticateUser.call(email, password)

    if command.success?
      render json: {
        access_token: command.result,
        message: 'Login Successful'
      }
    else
      render json: { error: command.errors }, status: :unauthorized
    end
   end
end