class InstructorProfilesController < ApplicationController
  before_action :set_instructor_profile, only: [:show, :update, :destroy]

  # GET /instructor_profiles
  def index
    @instructor_profiles = InstructorProfile.all

    render json: @instructor_profiles
  end

  # GET /instructor_profiles/1
  def show
    render json: @instructor_profile.as_json(
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
  end
  
  def get_info
    Rails.logger.info("get_info".colorize(:color => :white, :background => :blue))

    @instructor_profile = InstructorProfile.find_by(:id => params[:profile_id])

    lesson_requests = []
    is_public_profile = false

    if @instructor_profile.user.id == params[:user_id].to_i
      is_public_profile = false
    else
      is_public_profile = true
      lesson_requests = LessonRequest.where(:is_open => true, :student_id => params[:user_id].to_i, :instructor_id => @instructor_profile.user.id)
    end    

    render json: {
      :profile => @instructor_profile.as_json(
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
      ),
      :is_public_profile => is_public_profile,
      :lesson_requests => lesson_requests
    }
  end

  # POST /instructor_profiles
  def create
    @instructor_profile = InstructorProfile.new(
      :user_id => params[:instructor_profile][:id],
      :bio => params[:instructor_profile][:bio],
      :instructor_experience => params[:settings][:instructor_experience][:key],
      :main_instrument => params[:settings][:main_instrument][:key],
      :is_open_to_jam => params[:is_open_to_jam]
    )

    if @instructor_profile.save
      render json: @instructor_profile, status: :created, location: @instructor_profile
    else
      render json: @instructor_profile.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /instructor_profiles/1
  def update
    Rails.logger.info("update".colorize(:color => :white, :background => :blue))

    profile_params = {
      :bio => params[:instructor_profile][:bio],
      :instructor_experience => params[:settings][:instructor_experience][:key],
      :main_instrument => params[:settings][:main_instrument][:key],
      :is_open_to_jam => params[:is_open_to_jam]
    }

    if @instructor_profile.update(profile_params)
      render json: @instructor_profile
    else
      render json: @instructor_profile.errors, status: :unprocessable_entity
    end
  end

  # DELETE /instructor_profiles/1
  def destroy
    @instructor_profile.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_instructor_profile
      @instructor_profile = InstructorProfile.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def instructor_profile_params
      params.require(:instructor_profile).permit(:user_id, :months_playing, :main_instrument, :is_open_to_jam)
    end
end
