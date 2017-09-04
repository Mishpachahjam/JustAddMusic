Rails.application.routes.draw do

  resources :lessons
  resources :lesson_requests
  resources :messages
  resources :bridge_push_notifications
  resources :facebook_accounts
  resources :student_profiles
  resources :instructor_profiles
  resources :users
  resources :items

  post 'authenticate', to: 'authentication#authenticate'
  post 'authenticate_with_facebook', to: 'authentication#authenticate_with_facebook'

  get 'ping', to: 'application#ping'

  get 'get_instructor_profile_settings', to: 'application#get_instructor_profile_settings'
  get 'get_student_profile_settings', to: 'application#get_student_profile_settings'

  get 'get_available_students', to: 'application#get_available_students'
  get 'get_available_instructors', to: 'application#get_available_instructors'

  get "/users/:user_id/received_messages/sender/:sender_id" => "messages#get_messages"
  get "get_message_roster/:user_id" => "messages#get_message_roster"

  get "get_student_history/:user_id", to: 'application#get_student_history'
  get "get_instructor_history/:user_id", to: 'application#get_instructor_history'

  post "retrieve_student_record", to: "student_profiles#get_info"
  post "retrieve_instructor_record", to: "instructor_profiles#get_info"

  post "retrieve_student_lessons", to: "lessons#retrieve_student_lessons"
  post "retrieve_instructor_lessons", to: "lessons#retrieve_instructor_lessons"

  post "approve_lesson_request", to: "lesson_requests#approve"
  post "decline_lesson_request", to: "lesson_requests#decline"

  post "get_user_data/:user_id", to: "users#get_user_data"
end