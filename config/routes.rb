Rails.application.routes.draw do


  get 'oneschool/index'
  root "oneschool#index"

  #teacher
  get 'teacher/login', to: 'teacher#login', as: 'teacher_login'
  get 'teacher/home', to: 'teacher#home', as: 'teacher_home'
  get 'teacher/meeting', to: 'teacher#meeting', as: 'teacher_meeting'
  get 'teacher/profile', to: 'teacher#profile', as: 'teacher_profile'
  get 'teacher/classroom', to: 'teacher#ClassRoom', as: 'teacher_classroom'
  delete "teacher/checklogout", to: "teacher#checklogout", as: 'teacher_checklogout'
  post 'teacher/checklogin', to: 'teacher#checklogin', as: 'teacher_checklogin'
  post 'teacher/changepassword', to: 'teacher#changepassword', as: 'teacher_changepassword'
  #post 'teacher/accessclass', to: 'teacher#accessclass', as: 'teacher_accessclass'

  

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

  #admin
  get "/admin/signup", to: "admin#signup", as: "admin_signup"
  get "admin/manage", to: "admin#manage", as: "admin_manage"
  get "admin/login", to: "admin#login", as: "admin_login"
  post "/admin/create", to: "admin#create", as: "admin_create"
  post "/admin/createSchool", to: "admin#create_school", as: "admin_create_school"
  post "/admin/createStaff", to: "admin#create_staff", as: "admin_create_staff"
  post "/admin/editSchool", to: "admin#edit_school", as: "admin_edit_school"
  post "/admin/updateSchool", to: "admin#update_school", as: "admin_update_school"
  post "/admin/deleteSchool", to: "admin#delete_school", as: "admin_delete_school"

  delete "admin/checklogout", to: "admin#checklogout", as: 'admin_checklogout'
  post 'admin/checklogin', to: 'admin#checklogin', as: 'admin_checklogin'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # namespace :admin do
  #   resources :schools, only: [:new, :create, :destroy]
  # end
  # namespace :admin do
  #   resources :users
  # end
  
end
