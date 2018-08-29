class User < ApplicationRecord
	# attr_accessor :name, :password
  has_secure_password

  validates :name, presence: true, length: { in: 3..50 }, :on => :create, :on => :update

	validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: {
                      with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/
                    }

  validates :password, presence: true, :on => :create
  validates :password_confirmation, presence: true, on: :create
  validates_length_of :password, :in => 6..20, :on => :create, :on => :update


  before_save :downcase_email
  before_save :normalize_blank_values
  after_create :assign_customer_id, on: :create
  before_destroy :delete_stripe_customer

  has_many :surveys, dependent: :destroy
  has_many :questions
  has_many :solutions, dependent: :destroy
  has_many :feedbacks, dependent: :destroy
  has_many :devices, dependent: :destroy
  has_many :assigned_surveys
  has_many :services, dependent: :destroy

  has_one :profile, dependent: :destroy
  has_one :credit_card, dependent: :destroy

  after_create :init_profile
  accepts_nested_attributes_for :profile

  serialize :stripe_account_status, JSON

  scope :with_push_token, -> { where("push_token <> ''") }

  # before_create :generate_confirmation_instructions
  # @profile = JSON.parse(Net::HTTP.get_response(URI.parse("https://graph.facebook.com/me?access_token=" + params[:oauth] + "&appsecret_proof=" + OpenSSL::HMAC.hexdigest(OpenSSL::Digest::SHA256.new, FACEBOOK_CONFIG['secret'], params[:oauth]))).body.html_safe)["id"]
  #   if User.find_by_uid(@profile).nil?
  #     @profile = nil
  #   else
  #     id = User.find_by_uid(@profile).id
  #     @access_token = APIKey.find_by_user_id(id).access_token
  #     @name = User.find(id).name
  #     @first_name = User.find(id).first_name
  #   end

  def connected?; !stripe_id.nil?; end
  def custom?; stripe_account_type == 'custom'; end
  def standalone?; stripe_account_type == 'standalone'; end

  def customer
    case stripe_account_type
    when 'custom' then StripeCustom.new(self)
    when 'standalone' then StripeStandalone.new(self)
    # when 'oauth' then StripeOauth.new(self)
    end
  end

  def can_accept_charges?
    # return true if oauth?
    return true if custom? && stripe_account_status['charges_enabled']
    return true if standalone? && stripe_account_status['charges_enabled']
    return false
  end

  def init_profile
    self.build_profile.save(validate: false)
  end

  def downcase_email
    self.email = email.downcase
  end

  def has_payment_method?
    credit_card.present?
  end

  def generate_password_token!
    self.reset_password_token = generate_token
    self.reset_password_sent_at = Time.now.utc
    save!
  end

  def password_token_valid?
    (self.reset_password_sent_at + 4.hours) > Time.now.utc
  end

  def reset_password!(password)
    self.reset_password_token = nil
    self.password = password
    save!
  end

  def update_new_email!(email)
    self.unconfirmed_email = email
    self.generate_confirmation_instructions
    save
  end

  def gender
    self.profile.gender
  end

  def self.email_used?(email)
    existing_user = find_by("email = ?", email)

    if existing_user.present?
      return true
    else
      waiting_for_confirmation = find_by("unconfirmed_email = ?", email)
      return waiting_for_confirmation.present? && waiting_for_confirmation.confirmation_token_valid?
    end
  end

  def default_account_settings
    { type: 'custom' }
  end

  private

  def assign_customer_id
    customer = Stripe::Customer.create(email: email)
    self.stripe_id = customer.id
    self.stripe_account_type = 'custom'
    self.save
  end

  def delete_stripe_customer
    cu = Stripe::Customer.retrieve(self.stripe_id)
    cu.delete
  end

  def normalize_blank_values
    attributes.each do |column, value|
      self[column].present? || self[column] = nil
    end
  end

  def generate_token
    SecureRandom.hex(10)
  end
end

# User.where(birthdate: 65.years.ago..25.years.ago)
# User.where('to_date(birthdate, 'MM/YYYY') between ? and ?', 65.years.ago, 25.years.ago)