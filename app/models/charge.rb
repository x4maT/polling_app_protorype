class Charge
  attr_reader :amount, :customer, :currency

  def initialize(amount:, customer:, currency:, source: ,title:)
    @amount = amount
    @customer = customer
    @currency = currency
    @source = source
    @title = title
  end

  def self.application_fee(amount)
    (0.50 * amount).round(2)
  end

  def save
    stripe_charge = Stripe::Charge.create(
      amount: amount,
      customer: customer,
      currency: currency,
      source: @source,
      description: @title,
      destination: destination
      # ,
      # application_fee: application_fee_cents
    )
    stripe_charge.id
  end

  private

  def application_fee_cents
    (0.50 * amount).round
  end

  def destination
    'SOME ACCOUNT TO RECIEVE'
  end
end