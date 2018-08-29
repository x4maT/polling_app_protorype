module Api::V1::SocialAuthDoc
  extend Api::V1::BaseDoc
  namespace '/api/v1'
  
  doc_for :google do
    api :POST, '/v1/auth/google', 'User social authentication(/api/v1/auth(/:action))'
    param :token, String, desc: "",required: true
    param :push_token, String, desc: "",required: false
    example %q(
    	Request:
    	{
				"token": "ya29.Glu7BZ7Vxd4cYMJuIaE58s6...", #google oauth2 token from mobileApp
				"push_token": "a423bab29c9f174a026e1ca..." #mobile devise pushToken if user accepted push
    	}
    	Response:
    	{
    		"message": "User created Successful",
    		# If user already exist then: 
    		#"message": "Login successfully"
    		"email": "user@email.com",
    		"first_name": "Name",
    		"last_name":  "Surname",
    		"access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUz..."
    	}
    )
	end

	doc_for :facebook do
    api :POST, '/v1/auth/facebook', 'User social authentication(/api/v1/auth(/:action))'
	end
end