module Api::V1::AccountsDoc
  extend Api::V1::BaseDoc
  namespace '/api/v1'

  doc_for :create do
  	auth_headers
  	formats ['json']
  	api :POST, '/v1/accounts', 'Сreate payment account to respondent user(Stripe::Account create)'
  	param :first_name, String
  	param :last_name, String
  	param :type, String
  	param :personal_id_number, String
  	param :address, Array, required: false do
  		param :city, String
  		param :line1, String
  		param :postal_code, String
  		param :state, String
  	end
  	param :dob, Array, required: false do
  		param :day, String
  		param :month, String
  		param :year, String
  	end
  	param :tos_acceptance, Array, required: false do
  		param :date, DateTime
  		param :ip, String
  	end
  	example %q(
  	Request:
  	{
		#we dont need it now just empty request!!!! IMPORTANT
  	}
  	Response:
  	{
  		
  	}
  )
  end

    doc_for :external do
    	auth_headers
    	formats ['json']
    	api :POST, '/v1/external', 'Add bank account(DebitCard) to respondent'
    	param :external, Array, required: true do
    		param :token, String, required: true, desc: 'card token from mobile stripe sdk'
    	end

    	example %q(
    		Request:
    		{
    			external: 
    			{
					"token": "tok_1CR13GHyquYolWuNELgTere9" #card token from stripe
    			}
    		}
    		Response:
    		{
    			status: "created"
    		}
    	)
    end
end