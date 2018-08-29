class Api::V1::AccountsController < Api::V1::BaseController
    include Api::V1::AccountsDoc
	def create
		ip = remote_ip()
		p ip
		tos_acceptance = {date: Time.now.to_i, ip: ip}
		legal_entity_type = {type: "individual"}
    @account = Stripe::Account.create(
    																	type: 'custom', 
    																	country: 'US', 
    																	email: current_user.email, 
    																	tos_acceptance: tos_acceptance,
    																	legal_entity: legal_entity_type
    																	)


    current_user.stripe_account_id = @account.id
    current_user.stripe_account_type = 'custom'
    current_user.stripe_account_status = account_status
    current_user.save(validate: false)

    render json: {status: :created, ip: ip}

    rescue Stripe::InvalidRequestError => e
  		body = e.json_body
  		err  = body[:error]
  		puts "Message is: #{err[:message]}" if err[:message]
  		render json: {error: "Message is: #{err[:message]}"} if err[:message]
  	rescue Stripe::AuthenticationError => e
    	body = e.json_body
  		err  = body[:error]
  		puts "Message is: #{err[:message]}" if err[:message]
  		render json: {error: "Message is: #{err[:message]}"} if err[:message]
  	rescue Stripe::APIConnectionError => e
	    body = e.json_body
	  	err  = body[:error]
	  	puts "Message is: #{err[:message]}" if err[:message]
	  	render json: {error: "Message is: #{err[:message]}"} if err[:message]
  end

  def update_account_status
  	@account = Stripe::Account.retrieve(current_user.stripe_account_id)
  	current_user.stripe_account_status = account_status
    current_user.save(validate: false)
    render json: current_user.stripe_account_status
  end

  def external
    @account = Stripe::Account.retrieve(current_user.stripe_account_id)
    # puts '------------------CHECKING CARD TYPE---------------------'
    # card_type = Stripe::Token.retrieve(external_params[:token]).card.funding
    # p card_type
    # p card_type == "debit"
    # puts '---------------------------------------------------------'
    # return nil unless card_type
    # token = Stripe::Token.create(card: {currency: 'usd', number: 4000056655665556, exp_month: 12, exp_year: 2020, cvc: "123"})
    external = @account.external_accounts.create(external_account: external_params[:token])
    current_user.stripe_account_status = account_status
    current_user.save(validate: false)

    render json: {status: :created}

    rescue Stripe::CardError => e
    	body = e.json_body
  		err  = body[:error]
  		puts "Message is: #{err[:message]}" if err[:message]
  		render json: {error: "Message is: #{err[:message]}"} if err[:message]
  rescue Stripe::InvalidRequestError => e
  		body = e.json_body
  		err  = body[:error]
  		puts "Message is: #{err[:message]}" if err[:message]
  		render json: {error: "Message is: #{err[:message]}"} if err[:message]
  rescue Stripe::AuthenticationError => e
    	body = e.json_body
  		err  = body[:error]
  		puts "Message is: #{err[:message]}" if err[:message]
  		render json: {error: "Message is: #{err[:message]}"} if err[:message]
  rescue Stripe::APIConnectionError => e
    body = e.json_body
  	err  = body[:error]
  	puts "Message is: #{err[:message]}" if err[:message]
  	render json: {error: "Message is: #{err[:message]}"} if err[:message]
  end

  private

  def external_params
    params.require(:external).permit(:token)
  end

  # private

  def account_status
    {
      details_submitted: @account.details_submitted,
      charges_enabled: @account.charges_enabled,
      # transfers_enabled: account.transfers_enabled,
      fields_needed: @account.verification.fields_needed,
      due_by: @account.verification.due_by
    }
  end

 #  def account_params
 #    params.require(:account).permit(
 #      legal_entity:
 #        [:first_name, :last_name, :type, :personal_id_number,
 #         address: [:city, :line1, :postal_code, :state],
 #         dob: [:day, :month, :year]
 #        ],
 #      tos_acceptance: [:date, :ip]
 #    )
	# end
end