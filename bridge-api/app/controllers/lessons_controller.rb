class LessonsController < ApplicationController
  before_action :set_lesson, only: [:show, :update, :destroy]

  # GET /lessons
  def index
    @lessons = Lesson.all

    render json: {
      lessons: @lessons 
    }

  end

  def retrieve_student_lessons
    @lessons = Lesson.where(:student_id => params[:user_id]).order(created_at: :desc)

    render json: {
      lessons: @lessons.as_json(
        :methods => [
          :time_until
        ],
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

  def retrieve_instructor_lessons
    @lessons = Lesson.where(:instructor_id => params[:user_id]).order(created_at: :desc)

    render json: {
      lessons: @lessons.as_json(
        :methods => [
          :time_until
        ],
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

  # GET /lessons/1
  def show
    render json: @lesson.as_json(
      :methods => [
        :time_until
      ],
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
  end

  # POST /lessons
  def create
    @lesson = Lesson.new(lesson_params)

    if @lesson.save

      @sender = User.find_by_id(params[:instructor_id])
      @receiver = User.find_by_id(params[:student_id])
          
      Rails.logger.info("notification start")

      custom_data = {
        :data => nil
      }

      notification = BridgePushNotification.new(
        :receiver_id => @receiver.id,
        :message => "Your lesson have been scheduled!"
      )

      notification.save
      notification.send_to_user(@receiver, DEVELOPMENT_MODE, false, BRIDGE_NOTIFICATION_NEW_LESSON, custom_data)
      Rails.logger.info("notification end")

      render json: @lesson, status: :created, location: @lesson
    else
      render json: @lesson.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /lessons/1
  def update
    if @lesson.update(lesson_params)
      render json: @lesson
    else
      render json: @lesson.errors, status: :unprocessable_entity
    end
  end

  # DELETE /lessons/1
  def destroy
    @lesson.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lesson
      @lesson = Lesson.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def lesson_params
      params.require(:lesson).permit(:student_id, :instructor_id, :starts_at)
    end
end
