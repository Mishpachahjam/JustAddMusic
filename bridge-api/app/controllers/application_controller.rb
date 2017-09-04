class ApplicationController < ActionController::API
  before_action :authenticate_request, :except => [
  	:ping
  ]

  attr_reader :current_user
  # helper_method :current_user

  def ping
    Rails.logger.info("ping".colorize(:color => :white, :background => :blue))

    user = User.find_by(:id => 2)

    Rails.logger.info("notification start")
    custom_data = {
      :data => nil
    }

    notification = BridgePushNotification.new(
      :receiver_id => user.id,
      :message => "Bridge notification received!"
    )

    notification.save
    notification.send_to_user(user, DEVELOPMENT_MODE, false, BRIDGE_NOTIFICATION_NEW_MESSAGE, custom_data)
    Rails.logger.info("notification end")

    render json: {
    	error: "",
    	message: "pong"
    }, status: 200
  end


  def get_instructor_profile_settings
    settings = {
      main_instrument: {
        caption: "What is your main instrument?",
        options: INSTRUMENTS,
        element_type: UI_ELEMENTS[:PICKER]
      },
      instructor_experience: {
        caption: "How many years have you been playing?",
        options: INSTRUCTOR_EXPERIENCE,
        element_type: UI_ELEMENTS[:PICKER]
      }
    }
    render json: {
      error: "",
      settings: settings
    }, status: 200
  end

  def get_student_profile_settings
    settings = {
      main_instrument: {
        caption: "What is your main instrument?",
        options: INSTRUMENTS,
        element_type: UI_ELEMENTS[:PICKER]
      },
      playing_level: {
        caption: "What is your playing level?",
        options: STUDENT_LEVELS,
        element_type: UI_ELEMENTS[:PICKER]
      }
    }
    render json: {
      error: "",
      settings: settings
    }, status: 200
  end

  def get_available_students

    student_profiles = StudentProfile.all

    render json: {
      error: "",
      student_profiles: student_profiles.as_json(
        :include => {
          :user => {
            :only => [:id]
          },
          :facebook_account => {
              :only => [:first_name, :last_name, :picture_url]
          }
        },
        :methods => [
          :main_instrument_friendly,
          :playing_level_friendly
        ]
      )
    }, status: 200
  end

  def get_available_instructors

    instructor_profiles = InstructorProfile.all

    render json: {
      error: "",
      instructor_profiles: instructor_profiles.as_json(
        :include => {
          :user => {
            :only => [:id]
          },
          :facebook_account => {
              :only => [:first_name, :last_name, :picture_url]
          }
        },
        :methods => [
          :instructor_experience_friendly,
          :main_instrument_friendly
        ]
      )
    }, status: 200
  end

  def get_student_history
    Rails.logger.info("get_student_history".colorize(:color => :black, :background => :yellow))

    Rails.logger.info("user_id: #{params[:user_id]}")

    user = User.find_by(:id => params[:user_id])

    lesson_requests = LessonRequest.where(:student_id => params[:user_id]).order(created_at: :desc)

    render json: {
      lesson_requests: lesson_requests.as_json(
        :include => {
          :student => {
            :only => [:id],
            :include => {
              :facebook_account => {
                :only => [:first_name, :last_name, :picture_url]
              }
              # :student_profile
            }
          },
          :instructor => {
            :only => [:id],
            :include => {
              :facebook_account => {
                :only => [:first_name, :last_name, :picture_url]
              }
              # :student_profile
            }
          }
        }
      )
    }
    return
  end

  def get_instructor_history
    Rails.logger.info("get_instructor_history".colorize(:color => :black, :background => :yellow))

    Rails.logger.info("user_id: #{params[:user_id]}")

    user = User.find_by(:id => params[:user_id])

    lesson_requests = LessonRequest.where(:instructor_id => params[:user_id]).order(created_at: :desc)

    render json: {
      lesson_requests: lesson_requests.as_json(
        :include => {
          :student => {
            :only => [:id],
            :include => {
              :facebook_account => {
                :only => [:first_name, :last_name, :picture_url]
              }
              # :student_profile
            }
          },
          :instructor => {
            :only => [:id],
            :include => {
              :facebook_account => {
                :only => [:first_name, :last_name, :picture_url]
              }
              # :student_profile
            }
          }
        }
      )
    }
    return
  end

  private

  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result

    render json: {
    	error: 'Not Authorized'
    }, status: 401 unless @current_user
  end
end
