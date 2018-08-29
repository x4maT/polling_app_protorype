# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_05_12_190120) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "plpgsql"

  create_table "assigned_surveys", force: :cascade do |t|
    t.boolean "answered"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "survey_id"
    t.bigint "evaluated_user_id"
    t.index ["evaluated_user_id"], name: "index_assigned_surveys_on_evaluated_user_id"
    t.index ["survey_id"], name: "index_assigned_surveys_on_survey_id"
    t.index ["user_id"], name: "index_assigned_surveys_on_user_id"
  end

  create_table "completed_surveys", force: :cascade do |t|
    t.bigint "survey_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_id"], name: "index_completed_surveys_on_survey_id"
  end


  create_table "devices", force: :cascade do |t|
    t.bigint "user_id"
    t.string "uuid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_devices_on_user_id"
  end

  create_table "feedbacks", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "question_id"
    t.bigint "solution_id"
    t.bigint "survey_id"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_feedbacks_on_question_id"
    t.index ["solution_id"], name: "index_feedbacks_on_solution_id"
    t.index ["survey_id"], name: "index_feedbacks_on_survey_id"
    t.index ["user_id"], name: "index_feedbacks_on_user_id"
  end

  create_table "feedbacks_users", id: false, force: :cascade do |t|
    t.integer "feedback_id"
    t.integer "user_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "profiles", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "gender"
    t.date "birth_date"
    t.string "hh_income"
    t.string "first_name"
    t.string "last_name"
    t.string "education_level"
    t.string "life_style"
    t.string "relationship_status"
    t.string "life_stage"
    t.string "home_ownership"
    t.text "bio"
    t.jsonb "age_category", default: "{}", null: false
    t.boolean "is_completed", default: false, null: false
    t.string "image"
    t.index ["age_category"], name: "index_profiles_on_age_category", using: :gin
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "questions", force: :cascade do |t|
    t.text "text"
    t.string "type_violence"
    t.bigint "survey_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "content"
    t.bigint "solution_id"
    t.index ["solution_id"], name: "index_questions_on_solution_id"
    t.index ["survey_id"], name: "index_questions_on_survey_id"
  end

  create_table "services", force: :cascade do |t|
    t.bigint "user_id"
    t.string "provider"
    t.string "uid"
    t.string "access_token"
    t.string "access_token_secret"
    t.string "refresh_token"
    t.datetime "expires_at"
    t.text "auth"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_services_on_user_id"
  end

  create_table "solutions", force: :cascade do |t|
    t.bigint "survey_id"
    t.bigint "question_id"
    t.bigint "user_id"
    t.string "content"
    t.string "video"
    t.string "image"
    t.hstore "solution_rates", default: {}, null: false
    t.index ["question_id"], name: "index_solutions_on_question_id"
    t.index ["survey_id"], name: "index_solutions_on_survey_id"
    t.index ["user_id"], name: "index_solutions_on_user_id"
  end

  create_table "survey_results", force: :cascade do |t|
    t.integer "assigned_survey_id", null: false
    t.integer "answer_solution_id", null: false
    t.hstore "answer_solution_rates", default: {}, null: false
    t.text "answer_solution_feedback", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["answer_solution_id"], name: "index_survey_results_on_answer_solution_id"
    t.index ["assigned_survey_id"], name: "index_survey_results_on_assigned_survey_id"
  end

  create_table "surveys", force: :cascade do |t|
    t.string "title"
    t.string "user_type"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status"
    t.integer "survey_type"
    t.decimal "total_price", precision: 8, scale: 2
    t.decimal "cost_per_user", precision: 8, scale: 2
    t.integer "max_participants_count"
    t.hstore "target_audience", default: {}, null: false
    t.integer "respondents_count"
    t.string "survey_identifier"
    t.index ["user_type", "user_id"], name: "index_surveys_on_user_type_and_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string "unconfirmed_email"
    t.string "push_token"
    t.string "stripe_id"
    t.string "stripe_account_type"
    t.text "stripe_account_status", default: "{}"
    t.string "stripe_account_id"
  end

  add_foreign_key "assigned_surveys", "surveys"
  add_foreign_key "assigned_surveys", "users"
  add_foreign_key "assigned_surveys", "users", column: "evaluated_user_id"
  add_foreign_key "feedbacks", "questions"
  add_foreign_key "feedbacks", "solutions"
  add_foreign_key "feedbacks", "surveys"
  add_foreign_key "feedbacks", "users"
  add_foreign_key "profiles", "users"
  add_foreign_key "questions", "solutions"
  add_foreign_key "questions", "surveys"
  add_foreign_key "solutions", "questions"
  add_foreign_key "solutions", "surveys"
  add_foreign_key "solutions", "users"
end
