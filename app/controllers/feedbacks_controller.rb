class Api::V1::FeedbacksController < Api::V1::BaseController
  before_action :set_feedback, only: [:show, :update, :destroy]

  # GET /feedbacks
  def index
    @feedbacks = Feedback.all

    render json: @feedbacks
  end

  # GET /feedbacks/1
  def show
    render json: @feedback
  end

  # POST /feedbacks
  def create
    @feedback = Feedback.new(feedback_params)

    if @feedback.save
      render json: @feedback, status: :created, location: @feedback
    else
      render json: @feedback.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /feedbacks/1
  def update
    if @feedback.update(feedback_params)
      render json: @feedback
    else
      render json: @feedback.errors, status: :unprocessable_entity
    end
  end

  # DELETE /feedbacks/1
  def destroy
    @feedback.destroy
  end

  private

    def set_feedback
      @feedback = Feedback.find(params[:id])
    end

    def feedback_params
      params.require(:feedback).permit(:user_id, :question_id, :solution_id, :survey_id, :content)
    end
end