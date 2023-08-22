Rails.application.routes.draw do
  get 'oneschool/index'
  root "oneschool#index"

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
