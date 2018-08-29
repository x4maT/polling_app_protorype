class Api::V1::Auth::SocialController < ApplicationController
skip_before_action :authenticate_request
include Api::V1::SocialAuthDoc

  def facebook
    tok = params[:token]
    render json: {message: "facebook #{tok}"}
    # service = Service.where(provider: auth.provider, uid: auth.uid).first

    # if service.present?
    #   user = service.user
    #   service.update(
    #     expires_at: Time.at(auth.credentials.expires_at),
    #     access_token: auth_credentials.token
    #   )
    # else
    #   user = User.create(
    #     email: auth.info.email,
    #     # name: auth.info.nam,
    #     password: Devise.friendly_token[0, 20]
    #   )
    #   user.services.create(
    #     provider: auth.provider,
    #     uid: auth.uid,
    #     expires_at: Time.at(auth.credentials.expires_at),
    #     access_token: auth.credentials.token
    #   )
    # end
    # sign_in_and_redirect user, event: authentication
    # set_flash_message :notice, :success, kind: "Facebook"
  end

  def google

    push_token = params[:push_token]

    url = 'https://www.googleapis.com/oauth2/v2/userinfo'
    token = params[:token]
    response = RestClient.get url, {:Authorization => "Bearer #{token}"}
    data = JSON.parse(response)

    uid 	   =  data['id']
    email      =  data['email']
    name 	   =  data['email']
    first_name =  data['given_name']
    last_name  =  data['family_name']
    gender 	   =  data['gender']
    image_url  =  data['picture']

    service = Service.where(provider: 'google', uid: uid).first

    if service.present?
      user = service.user
      password = SecureRandom.hex(8)
      user.password = password
      user.push_token = push_token
      user.profile.first_name = first_name
      user.profile.last_name = last_name
      user.profile.remote_image_url = image_url
      user.save(validate: false)
      service.update(
      # expires_at: Time.at(auth.credentials.expires_at),
        access_token: token
      )

      tok = AuthenticateUser.call(user.email, password)

      json_response({ 
                      message: 'Login successfully',
                      email: user.email,
                      first_name: first_name,
                      last_name: last_name,
                      access_token: tok.result 
                    },:ok)
    else
      user = User.create(
                          name: data['name'],
                          email: email,
                          password: random_password = SecureRandom.hex(8),
                          password_confirmation: random_password,
                          push_token: push_token
                        )
      user.profile.first_name = first_name
      user.profile.last_name = last_name
      user.profile.remote_image_url = image_url
      user.profile.save(validate: false)
      user.services.create(
                           provider: 'google',
                           uid: uid,
                           # expires_at: Time.at(auth.credentials.expires_at),
                           access_token: token)
      Device.create(user: user, uuid: SecureRandom.uuid)
      tok = AuthenticateUser.call(user.email, user.password)

      json_response({ message: 'User created Successful',
                      email: user.email,
                      first_name: first_name,
                      last_name: last_name,
                      access_token: tok.result }, :ok)
    end
  end
  
  def handle(kind)
  end
  
end