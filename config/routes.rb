Rails.application.routes.draw do


  get 'oneschool/index'
  root "oneschool#index"

  #teacher
  get 'teacher/login', to: 'teacher#login', as: 'teacher_login'
  get 'teacher/home', to: 'teacher#home', as: 'teacher_home'
  get 'teacher/meeting', to: 'teacher#meeting', as: 'teacher_meeting'
 
  delete "teacher/checklogout", to: "teacher#checklogout", as: 'teacher_checklogout'
  post 'teacher/checklogin', to: 'teacher#checklogin', as: 'teacher_checklogin'

  

  #student
  get 'student/login', to: 'student#login', as: 'student_login'
  get 'student/home', to: 'student#home', as: 'student_home'

  delete "student/checklogout", to: "student#checklogout", as: 'student_checklogout'
  post 'student/checklogin', to: 'student#checklogin', as: 'student_checklogin'


  #family
  get 'family/login', to: 'family#login', as: 'family_login'
  get 'family/home', to: 'family#home', as: 'family_home'

  delete "family/checklogout", to: "family#checklogout", as: 'family_checklogout'
  post 'family/checklogin', to: 'family#checklogin', as: 'family_checklogin'



  

  get "/oneschool", to: "oneschool#index"

  #routes for admin:
  get "/admin/signup", to: "admin#signup"
  get "admin/manage", to: "admin#manage"
  post "/admin/create", to: "admin#create" 
  post "/admin/createSchool", to: "admin#create_school"
  post "/admin/createStaff", to: "admin#create_staff"
  post "/admin/editSchool", to: "admin#edit_school"
  post "/admin/updateSchool", to: "admin#update_school"
  post "/admin/deleteSchool", to: "admin#delete_school"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # namespace :admin do
  #   resources :schools, only: [:new, :create, :destroy]
  # end
  # namespace :admin do
  #   resources :users
  # end
  
end
