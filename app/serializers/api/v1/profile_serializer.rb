class Api::V1::ProfileSerializer < Api::V1::BaseSerializer
  belongs_to :user
  
  attributes :id, :gender, 
  			 :hh_income, :education_level, 
  			 :life_style, :relationship_status, 
  			 :life_stage, :home_ownership
end