class CreditCard < ApplicationRecord
  belongs_to :user
  validates :number, presence: true
  # validates :brand, presence: true
  # validates :fingerprint, presence: true
  validates :exp_month, presence: true
  validates :exp_year, presence: true
  validates :cvc, presence: true
  validates :last4_digits, presence: true

  attr_accessor :number, :cvc

  # customer.cards.first
  # elf.last4 = card[0].last4

  def set_last_digits
    if number
      number.to_s.gsub!(/\s/,'')
      self.digits ||= number.to_s.length <= 4 ? number : number.to_s.slice(-4..-1)
    end
  end
end
