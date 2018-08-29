class Api::V1::UsersController < Api::V1::BaseController
  include Api::V1::UsersDoc
  skip_before_action :authenticate_request, only: %i[login registration]

  def index
  end


  def registration
    @user = User.new(user_params)
    
    if @user.save
      Device.create(user: @user, uuid: SecureRandom.uuid)
      # Device.create(user: @user, uuid: @user.push_token)S
      tok = AuthenticateUser.call(@user.email, @user.password)

      UserMailer.with(user: @user).welcome_email.deliver_later
      
      response = { message: 'User created successfully', access_token: tok.result} 
      json_response({ response: response }, :created)
    else
      json_response({ errors: @user.errors }, :bad)
    end
  end

  def login
    authenticate params[:email], params[:password], params[:push_token]
  end

  def me
    render json: {
          user_id: current_user.id,
          stripe_id: current_user.stripe_id,
          email: current_user.email,
          name: current_user.name,
          push_token: current_user.push_token,
          profile: current_user.profile,
          created_at: current_user.created_at
        }
  end
 
  def update
    p = params[:password]
    name = params[:name].to_s
    if !p 
      current_user.name = name
      current_user.save(validate: false)
      render json: {status: 'Name updated'}, status: :ok
      return
    end
    if current_user.update(user_params)
      if current_user.reset_password!(params[:password])
        render json: {status: 'Password updated'}, status: :ok
      else
        render json: current_user.errors, status: :unprocessable_entity
      end
    else
      json_response(current_user.errors, :unprocessable_entity)
    end
  end

  def destroy
    # account = Stripe::Account.retrieve({ACCOUNT_ID})
    # account.deleteS
    current_user.destroy
  end

  def profile_update
    if current_user.profile.update(profile_params)
      render json: current_user.profile
    else
      render json: current_user.errors, status: :unprocessable_entity
    end
  end

  def external
    account = Stripe::Account.retrieve(current_user.account_id)
    external = account.external_accounts.create(external_account: external_params[:token])
    @customer.update!(bank_last_4_digits: external.last4, bank_name: external.bank_name)
    render :created
  end


#MB PRIVAT
  def email_update
  token = params[:token].to_s
  user = User.find_by(confirmation_token: token)

  if !user || !user.confirmation_token_valid?
    render json: {error: 'The email link seems to be invalid / expired. Try requesting for a new one.'}, status: :not_found
  else
    user.update_new_email!
    render json: {status: 'Email updated successfully'}, status: :ok
  end
end
#####
  private

  def validate_email_update
    @new_email = params[:email].to_s.downcase

    if @new_email.blank?
      return render json: { status: 'Email cannot be blank' }, status: :bad_request
    end

    if  @new_email == current_user.email
      return render json: { status: 'Current Email and New email cannot be the same' }, status: :bad_request
    end

    if User.email_used?(@new_email)
      return render json: { error: 'Email is already in use.' }, status: :unprocessable_entity
    end
  end

  def profile_params
    params.permit(:id,
                  :user_id, 
                  :image, 
                  :gender, 
                  :age_category, 
                  :hh_income, 
                  :education_level, 
                  :life_style, 
                  :relationship_status,
                  :life_stage, 
                  :home_ownership, 
                  :is_completed)
  end

  def user_params
    params.permit(
      :name,
      :email,
      :password,
      :password_confirmation,
      :push_token,
      :stripe_id,
      :stripe_account_id,
        profile_attributes: [:id, :user_id, :image,
                             :gender, :age_category,
                             :hh_income, :education_level,
                             :life_style, :relationship_status,
                             :life_stage, :home_ownership, :is_completed
                            ]
    )
  end

  def check_user_name_by_email(mail)
    user_name = User.find_by_email(mail).name
    return user_name
  end

  def authenticate(email, password, pushtoken)
    command = AuthenticateUser.call(email, password)
    if command.success?
      p '---------------------------'
      u = User.find_by_email(email)
      p pushtoken
      u.push_token = pushtoken
      u.save(validate: false)
      json_response({ message: 'Login Successful', access_token: command.result }, :ok)
    else
      json_response({ error: command.errors }, :unauthorized)
    end
   end
end