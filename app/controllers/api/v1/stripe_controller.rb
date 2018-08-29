class Api::V1::StripeController < ApplicationController
	
	def custom
		connector = StripeCustom.new( current_user )
		account = connector.create_account!(params[:country], params[:tos] == 'on', request.remote_ip)

		if account
			render json: {notice: "Managed Stripe account created! #{account.id}"}
		else
			render json: {error: "Unable to create Stripe account!"}
		end
	end

	def standalone
    connector = StripeStandalone.new( current_user )
    account = connector.create_account!( params[:country] )

    if account
      render json: {notice: "Standalone Stripe account created! #{account.id}"}
    else
      render json: {error: "Unable to create Stripe account!"}
    end
  end
end