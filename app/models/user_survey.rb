class UserSurvey < ActiveRecord::Base
	# belongs_to :survey
  belongs_to :user

  after_initialize :add_preferences_accessors
  # serialize :target_audience, HashSerializer
  serialize :target_audience
  
  store_accessor :target_audience, 
  							 :gender, 
  							 :age,
  							 :hh_income, 
  							 :education_level, 
  							 :life_style, 
  							 :relationship_status, 
  							 :life_stage, 
  							 :home_ownership

def target_audience_defaults
  { 
  	gender: 'Not important', 
  	age: '18,24', 
  	hh_income: 'Include all', 
  	education_level: 'Not important', 
  	lifestyle: 'Urban',
  	relationship_status: 'Not important',
  	life_stage: 'Not important',
  	home_ownership: 'Not important'
  }
end

def add_preferences_accessors
  self.class.store_accessor :target_audience, *(target_audience_defaults.keys)
end
end