module Api::V1::UsersDoc
  extend Api::V1::BaseDoc
  namespace '/api/v1'
  resource :users, formats: ['JSON'], short: 'app members'

  # doc_for :index do
  #   api :GET, '/v1/users', 'Fetch basic data about all users'
  #   param :id, :number, number: true
  # end

  doc_for :registration do
    api :POST, '/v1/auth/registration', 'User registration'
    formats %w(json)
    header :HTTP_ACCEPT, 'application/json', required: true

    param :user_name, String, desc: 'username', required: true
    param :email, /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/,desc: 'Email', required: true
    param :password, String, desc: 'password', required: true
    param :password_confirmation, String, desc: 'password confirmation', required: true
    param :push_token, String, desc: 'device push token', required: false
    # param :param_with_metadata, String, :desc => "", :meta => [:your, :custom, :metadata]

    error code: 500, desc: '{"errors": {"email": ["has already been taken"]}}'
    error code: 500, desc: '{"errors": {"password_confirmation": ["doesnt match Password"]}}'
    error code: 500, desc: '{"errors": {"email": ["is invalid"]}}'
    error code: 500, desc: '{
    "errors": {
        "password": [
            "cant be blank"
        ],
        "email": [
            "cant be blank",
            "is invalid"
        ],
        "password_confirmation": [
            "cant be blank"
        ]
    }
}'

    example %q(
              Request:
              {
               "user":
                 {
                    "username": "UserName"
                    "email":"hello@domain.com",
                    "password":"password", # minimum length 6 chars
                    "password_confirmation":"password",
                    "push_token": "{device push token}" # If User accepted push notifications
                  }
              }
              Response:
              {
                "message": "User created successfully",
                "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI..." #Generated access token
               }
            )
  end

  doc_for :login do
    api :POST, '/v1/auth/login', 'User basic authentication'
    formats ['json']
    error code: 401, desc: 'Unauthorized'
    param :email, String, required: true, desc: "User email"
    param :password, String, required: true, desc: "User password"
    param :push_token, String, required: false, desc: "User Device push token if present..."
    error code: 401, desc: '
      "error": {
        "user_authentication": [
            "invalid credentials"
        ]
    }'
    example %q(
      Request:
      {
        "email": "doc@doc.com",
        "password": "123321",
        "push_token": "6c917f7bb279b58378db95109e64..." #or nil if user didnt accept push notification
      }
      Response:
      #status 200 OK
      {
        "message": "Login Successful",
        "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..."
      }
    )
  end

  doc_for :profile_update do
    auth_headers
    api :POST, '/v1/profile/update', 'Update User Profile attributes'
    formats %w(json)

    param :profile, Array, :desc => "User profile", required: true do
      param :user_id, Integer, required: true, desc: "Profile belongs_to user_id"
      param :first_name, String
      param :last_name, String
      param :birth_date, DateTime
      param :gender, String
      param :age_category, String, desc: "Target audience data, is updated after the user became a respondent example: (18-24)"
      param :hh_income, String, desc: 'Target audience data, is updated after the user became a respondent, example (Below $30k)'
      param :education_level, String, desc: 'Target audience data, is updated after the user became a respondent, example (College)'
      param :life_style, String, desc: 'Target audience data, is updated after the user became a respondent, example (Urban)'
      param :relationship_status, String, desc: 'Target audience data, is updated after the user became a respondent, example (Single)'
      param :life_stage, String, desc: 'Target audience data, is updated after the user became a respondent, example (No kids at home)'
      param :home_ownership, String, desc: 'Target audience data, is updated after the user became a respondent, example (Own a Home)'
      param :is_completed, [true, false], desc: 'Must be true when user become as respondent'

      param :image, Array, :desc => "User profile", required: true do
        param :url, String, :desc => "Image(avatar) path url"
      end
    end
    example %q(
      Request:
      {
        "first_name": "value",
        "last_name": "value",
        "birth_date": "value",
        "gender": "Male",
        "hh-income": "Below $30K",
        "education-level": "value",
        "life-style": "value",
        "relationship-status": "value",
        "life-stage": "value",
        "home-ownership": "value",
        "is_completed": true
      }
      Response:
      {
        "data": {
        "id": "3",
        "type": "profiles",
        "attributes": {
            "gender": "Male",
            "hh-income": "Below $30K",
            "education-level": "value",
            "life-style": "value",
            "relationship-status": "value",
            "life-stage": "value",
            "home-ownership": "value"
        },
        "relationships": {
            "user": {
                "data": {
                    "id": "3",
                    "type": "users"
                }
            }
        }
      }
      }
    )
  end

  doc_for :update do
    auth_headers
    api :PUT, '/v1/users/:user_id/', 'Update an User Password/Name'
    formats %w(json)
    param :name, String, required: false
    param :password, String, required: false
    example %q(
      Request:
      {
        "name": "NewName"
        "password": "NewPass"
      }
      Response:
      {
        "status": "Password updated",
        "status": "Name updated"
      }
    )
  end

  doc_for :me do
    auth_headers
    api :GET, '/v1/me', 'Fetch detailed data about a user, requires authentication'
    formats %w(json)
    error code: 404, desc: 'User not found'
    
    param :user, Array, :desc => "User", required: true do
    param :id, Fixnum, :desc => "User ID", :required => true
    param :stripe_id, String, required: true
    # param :stripe_account_id, String, desc: "Need update when user became as respondent(To transfer reward money)"
    param :email, String, required: true
    param :name, String, required: true
    param :push_token, String
    param :created_at, DateTime, required: true
    param :updated_at, DateTime, required: true

      param :profile, Array, :desc => "User profile", required: true do
        param :first_name, String
        param :last_name, String
        param :birth_date, DateTime
        param :gender, String
        param :age_category, String, desc: "Target audience data, is updated after the user became a respondent example: (18-24)"
        param :hh_income, String, desc: 'Target audience data, is updated after the user became a respondent, example (Below $30k)'
        param :education_level, String, desc: 'Target audience data, is updated after the user became a respondent, example (College)'
        param :life_style, String, desc: 'Target audience data, is updated after the user became a respondent, example (Urban)'
        param :relationship_status, String, desc: 'Target audience data, is updated after the user became a respondent, example (Single)'
        param :life_stage, String, desc: 'Target audience data, is updated after the user became a respondent, example (No kids at home)'
        param :home_ownership, String, desc: 'Target audience data, is updated after the user became a respondent, example (Own a Home)'
        param :is_completed, [true, false], desc: 'Must be true when user become as respondent'

        param :image, Array, :desc => "User profile", required: true do
          param :url, String, :desc => "Image(avatar) path url"
        end
      end
    end
    example %q(
      Response:
      {
        "user_id": 1,
        "stripe_id": "cus_CrlYfsIp1CXUvO",
        "email": "user@email.com",
        "name": "UserName(nickname)",
        "push_token": null,
        "profile": {
            "id": 1,
            "user_id": 1,
            "created_at": "2018-05-15T12:12:30.594Z",
            "updated_at": "2018-05-15T12:12:30.594Z",
            "gender": null,
            "birth_date": null,
            "hh_income": null,
            "first_name": null,
            "last_name": null,
            "education_level": null,
            "life_style": null,
            "relationship_status": null,
            "life_stage": null,
            "home_ownership": null,
            "bio": null,
            "age_category": "{}",
            "is_completed": false,
            "image": {
                "url": null
            }
        },
        "created_at": "2018-05-15T12:12:26.874Z"
      }
    )
  end
end