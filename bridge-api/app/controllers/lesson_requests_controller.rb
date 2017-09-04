class LessonRequestsController < ApplicationController
  before_action :set_lesson_request, only: [:show, :update, :destroy]

  # GET /lesson_requests
  def index
    @lesson_requests = LessonRequest.all

    render json: @lesson_requests
  end

  # GET /lesson_requests/1
  def show
    render json: {
      lesson_request: @lesson_request.as_json(
        :include => {
          :student => {
            :only => [:id],
            :include => {
              :facebook_account => {
                :only => [:first_name, :last_name, :picture_url]
              },
              :student_profile => {}
            }
          },
          :instructor => {
            :only => [:id],
            :include => {
              :facebook_account => {
                :only => [:first_name, :last_name, :picture_url]
              },
              :instructor_profile => {}
            }
          }
        }
      )
    }
  end

  # POST /lesson_requests
  def create
    @lesson_request = LessonRequest.new(lesson_request_params)

    @lesson_request.is_open = true
    
    if @lesson_request.save

      @sender = User.find_by_id(params[:student_id])
      @receiver = User.find_by_id(params[:instructor_id])
          
      Rails.logger.info("notification start")

      custom_data = {
        :data => nil
      }

      notification = BridgePushNotification.new(
        :receiver_id => @receiver.id,
        :message => "You've got a lesson request!"
      )

      notification.save
      notification.send_to_user(@receiver, DEVELOPMENT_MODE, false, BRIDGE_NOTIFICATION_NEW_LESSON_REQUEST, custom_data)
      Rails.logger.info("notification end")

      render json: @lesson_request, status: :created, location: @lesson_request
    else
      render json: @lesson_request.errors, status: :unprocessable_entity
    end
  end

  def approve
    @lesson_request = LessonRequest.find_by(:id => params[:lesson_request_id])

    @lesson_request.is_open = false
    @lesson_request.is_approved = true

    if @lesson_request.save

      # @sender = User.find_by_id(params[:student_id])
      # @receiver = User.find_by_id(params[:instructor_id])
          
      # Rails.logger.info("notification start")

      # custom_data = {
      #   :data => nil
      # }

      # notification = BridgePushNotification.new(
      #   :receiver_id => @receiver.id,
      #   :message => "Your got a lesson request!"
      # )

      # notification.save
      # notification.send_to_user(@receiver, DEVELOPMENT_MODE, false, BRIDGE_NOTIFICATION_NEW_LESSON_REQUEST, custom_data)
      # Rails.logger.info("notification end")

      render json: @lesson_request, status: :created, location: @lesson_request
    else
      render json: @lesson_request.errors, status: :unprocessable_entity
    end
  end

  def decline
    @lesson_request = LessonRequest.find_by(:id => params[:lesson_request_id])

    @lesson_request.is_open = false
    @lesson_request.is_denied = true
    
    if @lesson_request.save

      @receiver = User.find_by_id(params[:student_id])
      @sender = User.find_by_id(params[:instructor_id])
          
      Rails.logger.info("notification start")

      custom_data = {
        :data => nil
      }

      notification = BridgePushNotification.new(
        :receiver_id => @receiver.id,
        :message => "Your lesson request was denied."
      )

      notification.save
      notification.send_to_user(@receiver, DEVELOPMENT_MODE, false, BRIDGE_NOTIFICATION_LESSON_REQUEST_DENIED, custom_data)
      Rails.logger.info("notification end")

      render json: @lesson_request, status: :created, location: @lesson_request
    else
      render json: @lesson_request.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /lesson_requests/1
  def update
    if @lesson_request.update(lesson_request_params)
      render json: @lesson_request
    else
      render json: @lesson_request.errors, status: :unprocessable_entity
    end
  end

  # DELETE /lesson_requests/1
  def destroy
    @lesson_request.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lesson_request
      @lesson_request = LessonRequest.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def lesson_request_params
      params.require(:lesson_request).permit(:student_id, :instructor_id, :lesson_bounty, :lesson_description, :starts_at)
    end
end
