Rails.application.routes.draw do

  root 'family#login'

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


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
