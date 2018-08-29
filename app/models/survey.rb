class Survey < ApplicationRecord

  after_create :add_preferences_accessors
  before_create :set_total_price
  before_save :normalize_blank_values
  after_initialize :check_total_price_present
  # before_validation :check_total_price_present
  
  # validates :total_price, presence: true, :on => :create
  
  store_accessor :target_audience, 
                 :gender, 
                 :age_category,
                 :hh_income, 
                 :education_level, 
                 :life_style, 
                 :relationship_status, 
                 :life_stage, 
                 :home_ownership

  belongs_to :user, polymorphic: true
  
  has_many :questions, dependent: :destroy
  has_many :solutions, dependent: :destroy
  has_many :feedbacks, dependent: :destroy
  has_many :assigned_surveys, dependent: :destroy

  
  accepts_nested_attributes_for :solutions, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :questions, reject_if: :all_blank, allow_destroy: true
 
  validates :cost_per_user, presence: true, 
            numericality: { greater_than: 0, less_than_or_equal_to: 10 }, :on => :create

  validates :max_participants_count, presence: true, :numericality => {:only_integer => true, greater_than: 0, less_than_or_equal_to: 50 }, :on => :create 

  enum status: {draft: 0, open: 1, closed: 2, canceled: 3}
  enum survey_type: {single_question: 0, multiple_question: 1, test_multiple_question: 2}

  scope :status, -> (status) { where status: status }
  scope :with_type, -> (type) { where survey_type: type }
  scope :with_gender, -> (value) { where("target_audience-> 'gender' = ?", value) }
  scope :with_age_category, -> (age_category) { where("target_audience -> 'age_category' like ?", age_category)}
  scope :with_hh_income, -> (hh_income) { where("target_audience -> 'hh_income' like ?", hh_income)}
  scope :with_education_level, -> (education_level) { where("target_audience -> 'education_level' like ?", education_level)}
  scope :with_life_style, -> (life_style) { where("target_audience -> 'life_style' like ?", life_style)}
  scope :with_relationship_status, -> (relationship_status) { where("target_audience -> 'relationship_status' like ?", relationship_status)}
  scope :with_life_stage, -> (life_stage) { where("target_audience -> 'life_stage' like ?", life_stage)}
  scope :with_home_ownership, -> (home_ownership) { where("target_audience -> 'home_ownership' like ?", home_ownership)}

  def target_audience_defaults
    Rails.logger.info "AfterInit #{self}"
  { 
    gender: "Not important", 
    age_category: "18-24", 
    hh_income: "Include all", 
    education_level: "Not important", 
    life_style: "Urban",
    relationship_status: "Not important",
    life_stage: "Not important",
    home_ownership: "Not important"
  }
end

  def get_survey_type
    self.survey_type
  end

  def add_preferences_accessors
    self.class.store_accessor :target_audience, *(target_audience_defaults.keys)
  end

  def normalize_blank_values
    attributes.each do |column, value|
      self[column].present? || self[column] = nil
    end
  end

  private

  def set_total_price
    max_participants_count = self.max_participants_count.present? ? self.max_participants_count : self.max_participants_count = 10
    cost_per_user = self.cost_per_user.present? ? self.cost_per_user : self.cost_per_user = 10

    price = max_participants_count * cost_per_user
    self.total_price = price
  end

  def check_total_price_present
    # test-expression ? if-true-expression : if-false-expression
    self.total_price.present? ? self.total_price : set_total_price
  end

	# def payment_params
	# 	params.require(:payment).permit(:type)
	# end
end
