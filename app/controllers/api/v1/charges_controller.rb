class Api::V1::ChargesController < Api::V1::BaseController
	
  def new
		amount 	 = params[:amount]
		token 	 = params[:token]
		customer = params[:customer]
		customer = Stripe::Customer.retrieve(customer)
		card_fingerprint = Stripe::Token.retrieve(token).try(:card).try(:fingerprint) 
		default_card = customer.sources.all.data.select{|card| card.fingerprint ==  card_fingerprint}.last if card_fingerprint 
		default_card = customer.sources.create({:card => token}) unless default_card 
		customer.default_card = default_card.id 
		customer.save 
		begin
      		charge = Stripe::Charge.create(
      		:amount => amount,
      		:customer => customer,
      		:currency => "usd",
      		:description => "Idea payment",
      		metadata: {'order_id' => SecureRandom.hex(10)}
    		)
  		rescue Stripe::CardError => e
  			body = e.json_body
  			err  = body[:error]
  			puts "Message is: #{err[:message]}" if err[:message]
  			render json: {error: "Message is: #{err[:message]}"} if err[:message]
  	end
  		p "-------------------CHARGE ID FROM CHARGES CONTROLLER-------------------"
  		p charge.id
  		p "----------------------------CHARGE STATUS------------------------------"
  		p "--------------------------#{charge.status}-----------------------------"
  		render json: {
  						message: 'Success', 
  					 	charge_id: "#{charge.id}", 
  					 	status: "#{charge.status}"
  					 }
	end
end