class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  before_action :authenticate_request, :except => [
    :create
  ]

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    Rails.logger.info("users/create".colorize(:color => :white, :background => :blue))

    if params[:facebook_data]
      Rails.logger.info("#{params[:facebook_data]}")

      @user = User.new(
        :email => params[:facebook_data][:email],
        :password => "bridge"
      )

      if @user.save
        @facebook_account = FacebookAccount.new(
          :user_id => @user.id,
          :access_token => params[:facebook_access_token],
          :facebook_account_id => params[:facebook_data][:id],
          :email => params[:facebook_data][:email],
          :first_name => params[:facebook_data][:first_name],
          :last_name => params[:facebook_data][:last_name],
          :picture_url => params[:facebook_data][:picture][:data][:url]
        )
        if @facebook_account.save

          command = AuthenticateUser.call(params[:facebook_data][:email], 'bridge')

          if command.success?
            render json: {
              auth_token: command.result[:auth_token],
              user: command.result[:user].as_json(:include => :facebook_account)
            }, status: :created, location: @user
          else
            render json: { 
              error: command.errors 
            }, status: :unauthorized
          end
        else
          render json: @facebook_account.errors, status: :unprocessable_entity
        end
      else
        render json: @user.errors, status: :unprocessable_entity
      end

    else
      @user = User.new(user_params)
      if @user.save
        render json: @user, status: :created, location: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end
  end

  def get_user_data
    Rails.logger.info("get_user_data".colorize(:color => :white, :background => :blue))

    Rails.logger.info(params[:user_id])

    lesson_requests = []
    lessons = []

    if params[:is_student]
      Rails.logger.info("is_student")

      profile = StudentProfile.find_by(:user_id => params[:user_id])

      lesson_requests = LessonRequest.where(:is_open => true, :student_id => params[:user_id])
      lessons = Lesson.where(:student_id => params[:user_id]).where("starts_at > ?", DateTime.current)
    elsif params[:is_instructor]
      Rails.logger.info("is_instructor")

      profile = InstructorProfile.find_by(:user_id => params[:user_id])

      lesson_requests = LessonRequest.where(:is_open => true, :instructor_id => params[:user_id])
      lessons = Lesson.where(:instructor_id => params[:user_id]).where("starts_at > ?", DateTime.current)
    end

    render json: { 
      lesson_count: lessons.count,
      lesson_request_count: lesson_requests.count
    }
  end

  # PATCH/PUT /users/1
  def update
    Rails.logger.info("users/update".colorize(:color => :white, :background => :blue))

    if params[:push_token]
      @user.push_token = params[:push_token]
      if @user.save
        render json: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
      return
    end

    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    # def user_params
    #   params.require(:user).permit(:name, :email, :password_digest, :is_student, :is_instructor)
    # end

    def user_params
      params.permit(:email, :password)
    end
end
