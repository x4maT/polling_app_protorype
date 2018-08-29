module Api::V1::SurveysDoc
  extend Api::V1::BaseDoc
  namespace '/api/v1'

  doc_for :create do
  	auth_headers
  	api :POST, "/v1/users/:user_id/surveys", "Create Survey"
  	formats ['json']
  	error :code => 401, :desc => "Unauthorized"
  	error :code => 400, :desc => "Nil JSON web token"
  	param :survey, Array, :desc => "Survey params", required: true do
  		param :title, String, :desc => "Survey title(now its takes from first question)"
  		param :survey_type, ['single_question', 'multiple_question'], :desc => "Survey Type", required: true
  		# enum status: {draft: 0, open: 1, closed: 2, canceled: 3}
  		param :status, ['open', 'closed'], :desc => 'survey enum status: {draft: 0, open: 1, closed: 2, canceled: 3}', required: true
  		param :max_participants_count, Integer, required: true, :desc => "Max participants count per Survey", :required => true
  		param :cost_per_user, Float, :desc => "Price per user default 10", :required => true
  		
  		param :target_audience, Array, desc: "Survey Target audience params", :required => true do
  			param :gender, String, :required => true
  			param :age_category, String, :required => true
  			param :hh_income, String, :required => true
  			param :education_level, String, :required => true
  			param :life_style, String, :required => true
  			param :relationship_status, String, :required => true
  			param :life_stage, String, :required => true
  			param :home_ownership, String, :required => true
  		end
  	end
  	example %q(
  		Request:
  		{
			   "title":"Survey Title",
			   "survey_type":"multiple_question",
			   "status":"open",
			   "max_participants_count":10,
			   "cost_per_user": 10,
			   "target_audience":{
			      "gender":"Include All",
			      "age_category":"Include All",
			      "hh_income":"Include All",
			      "education_level":"Include All",
			      "life_style":"Include All",
			      "relationship_status":"Include All",
			      "life_stage":"Include All",
			      "home_ownership":"Include All"
			   },
			   "questions_attributes":[
			      {
			         "content":"Would you like a piece of cake?"
			      }
			   ],
			   "solutions_attributes":[
			      {
			         "content":"first options content",
			         "solution_rates":{}
			      },
			      {
			         "content":"second options Content",
			         "solution_rates":{}
			      }
			   ]
  		}
  		Response:
  		{
				"data": {
        "id": "20",
        "type": "surveys",
        "attributes": {
            "title": "Survey Title",
            "survey-type": "multiple_question",
            "status": "open",
            "max-participants-count": 10,
            "respondents-count": null,
            "cost-per-user": "10.0",
            "total-price": "100.0",
            "target-audience": {
                "gender": "Include All",
                "age-category": "Include All",
                "hh-income": "Include All",
                "education-level": "Include All",
                "life-style": "Include All",
                "relationship-status": "Include All",
                "life-stage": "Include All",
                "home-ownership": "Include All"
            }
        },
        "relationships": {
            "questions": {
                "data": [
                    {
                        "id": "20",
                        "type": "questions"
                    }
                ]
            },
            "solutions": {
                "data": [
                    {
                        "id": "23",
                        "type": "solutions"
                    },
                    {
                        "id": "24",
                        "type": "solutions"
                    }
                ]
            },
            "user": {
                "data": {
                    "id": "3",
                    "type": "users"
                }
            }
        }
    }
  		}
  	)	
  end

  doc_for :index do
  	auth_headers
  	api :GET, "/v1/users/:user_id/surveys", "Show surveys by user owner"
  	formats ['json']
  	error :code => 401, :desc => "Unauthorized"
  	error :code => 400, :desc => "Nil JSON web token"
  	example %q(
              Response:
              {
			    "data": [
			        {
			            "id": "18",
			            "type": "surveys",
			            "attributes": {
			                "title": "Awesome Idea Survey",
			                "survey-type": "single_question",
			                "status": "open",
			                "max-participants-count": 10,
			                "respondents-count": null,
			                "cost-per-user": "10.0",
			                "total-price": "100.0",
			                "target-audience": {
			                    "gender": "Male",
			                    "hh-income": "Include All",
			                    "life-stage": "Include All",
			                    "life-style": "Include All",
			                    "age-category": "Include All",
			                    "home-ownership": "Include All",
			                    "education-level": "Include All",
			                    "relationship-status": "Include All"
			                }
			            },
			            "relationships": {
			                "questions": {
			                    "data": [
			                        {
			                            "id": "18",
			                            "type": "questions"
			                        }
			                    ]
			                },
			                "solutions": {
			                    "data": [
			                        {
			                            "id": "20",
			                            "type": "solutions"
			                        }
			                    ]
			                },
			                "user": {
			                    "data": {
			                        "id": "2",
			                        "type": "users"
			                    }
			                }
			            }
			        },
            )
  end

  doc_for :show do
  	auth_headers
  	api :GET, "/v1/users/:user_id/surveys/:survey_id", "Show survey full info"
  	formats ['json']
  	error :code => 401, :desc => "Unauthorized"
  	error :code => 400, :desc => "Nil JSON web token"
  	example %q(
              Response:
              {
              	"survey": {
			        "id": 13,
			        "title": "Survey title",
			        "user_id": 2,
			        "target_audience": {
			            "gender": "Male",
			            "hh_income": "Include All",
			            "life_stage": "Include All",
			            "life_style": "Include All",
			            "age_category": "Include All",
			            "home_ownership": "Include All",
			            "education_level": "Include All",
			            "relationship_status": "Include All"
			        }
			    },
			    "percentage": [],
			    "respondents_count": 0,
			    "solutions": [
			        {
			            "id": 15,
			            "question_id": 13,
			            "content": "first options content",
			            "video": {
			                "url": null
			            },
			            "image": {
			                "url": null
			            },
			            "solution_rates": {},
			            "feedbacks": []
			        }
			    ]	
			  }
            )
  end

  doc_for :save_survey_answers do
  	api :POST, "/v1/users/:user_id/surveys/:survey_id", "Answer to survey"
  	param :user_id, Integer, :required => true
  	param :survey_id, Integer, :required => true
		param :answer_solution_id, Integer, :required => true
		param :answer_solution_rates, Array, :required => true do
			param :shareability, Float, :required => true
			param :relevance, Float, :required => true
			param :uniqueness, Float, :required => true
			param :usefulness, Float, :required => true
			param :purchase_intent, Float, :required => true
		end
  	example %q(
  		Request:
  		{
				"user_id": 2,
				"survey_id": 1,
				"answer_solution_id": 1,
				"answer_solution_rates":
				{
					"shareability":   5,
					"relevance":      5,
					"uniqueness":     5,
        	"usefulness":     5,
        	"purchase_intent":5
				},
				"answer_solution_feedback": "My Feedback"
			}
			Response:
			{
				"message": "Success"
			}
  	)
  end
end