class StudentProfilesController < ApplicationController
  before_action :set_student_profile, only: [:show, :update, :destroy]
  
  # GET /student_profiles
  def index
    @student_profiles = StudentProfile.all

    render json: @student_profiles
  end

  # GET /student_profiles/1
  def show
    render json: @student_profile.as_json(
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
  end

  def get_info
    Rails.logger.info("get_info".colorize(:color => :white, :background => :blue))

    @student_profile = StudentProfile.find_by(:id => params[:profile_id])

    lesson_requests = []
    is_public_profile = false

    if @student_profile.user.id == params[:user_id].to_i
      is_public_profile = false
    else
      is_public_profile = true
      lesson_requests = LessonRequest.where(:is_open => true, :instructor_id => params[:user_id].to_i, :student_id => @student_profile.user.id)
    end   

    render json: {
      :profile => @student_profile.as_json(
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
      ),
      :is_public_profile => is_public_profile,
      :lesson_requests => lesson_requests
    }
  end

  # POST /student_profiles
  def create
    @student_profile = StudentProfile.new(
      :user_id => params[:student_profile][:id],
      :bio => params[:student_profile][:bio],
      :playing_level => params[:settings][:playing_level][:key],
      :main_instrument => params[:settings][:main_instrument][:key],
      :is_open_to_jam => params[:is_open_to_jam]
    )

    if @student_profile.save
      render json: @student_profile, status: :created, location: @student_profile
    else
      render json: @student_profile.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /student_profiles/1
  def update
    Rails.logger.info("update".colorize(:color => :white, :background => :blue))

    profile_params = {
      :bio => params[:student_profile][:bio],
      :playing_level => params[:settings][:playing_level][:key],
      :main_instrument => params[:settings][:main_instrument][:key],
      :is_open_to_jam => params[:is_open_to_jam]
    }

    if @student_profile.update(profile_params)
      render json: @student_profile
    else
      render json: @student_profile.errors, status: :unprocessable_entity
    end
  end

  # DELETE /student_profiles/1
  def destroy
    @student_profile.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student_profile
      @student_profile = StudentProfile.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def student_profile_params
      params.require(:student_profile).permit(:user_id, :level, :main_instrument, :is_open_to_jam)
    end
end
