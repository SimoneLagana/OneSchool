Rails.application.routes.draw do
  get 'school/home'
  get 'school/login'


  get 'oneschool/index'
  root "oneschool#index"

  #teacher
  get 'teacher/login', to: 'teacher#login', as: 'teacher_login'
  get 'teacher/home', to: 'teacher#home', as: 'teacher_home'
  get 'teacher/meeting', to: 'teacher#meeting', as: 'teacher_meeting'
  get 'teacher/commitment', to: 'teacher#commitment', as: 'teacher_commitment'
  post 'teacher/managecommitment', to: 'teacher#managecommitment', as: 'teacher_managecommitment'
  get 'teacher/grade', to: 'teacher#grade', as: 'teacher_grade'
  post 'teacher/insertgrade', to: 'teacher#insertgrade', as: 'teacher_insertgrade'
  get 'teacher/profile', to: 'teacher#profile', as: 'teacher_profile'
  get 'teacher/classroom', to: 'teacher#classroom', as: 'teacher_classroom'
  delete "teacher/checklogout", to: "teacher#checklogout", as: 'teacher_checklogout'
  post 'teacher/checklogin', to: 'teacher#checklogin', as: 'teacher_checklogin'
  post 'teacher/changepassword', to: 'teacher#changepassword', as: 'teacher_changepassword'
  get 'teacher/upgradepassword', to: 'teacher#upgradepassword', as: 'teacher_upgradepassword'
  get 'teacher/absence', to: 'teacher#absence', as: 'teacher_absence'
  post 'teacher/insertabsence', to: 'teacher#insertabsence', as: 'teacher_insertabsence'
  get 'teacher/note', to: 'teacher#note', as: 'teacher_note'
  post 'teacher/insertnote', to: 'teacher#insertnote', as: 'teacher_insertnote'
  get 'teacher/homework', to: 'teacher#homework', as: 'teacher_homework'
  post 'teacher/managehomework', to: 'teacher#managehomework', as: 'teacher_managehomework'
  get 'teacher/requestmeeting', to: 'teacher#requestmeeting', as: 'teacher_requestmeeting'
  post 'teacher/insertmeeting', to: 'teacher#insertmeeting', as: 'teacher_insertmeeting'
  get 'teacher/communication', to: 'teacher#communication', as: 'teacher_communication'


  #student
  get 'student/login', to: 'student#login', as: 'student_login'
  get 'student/home', to: 'student#home', as: 'student_home'

  post 'student/changepassword', to: 'student#changepassword', as: 'student_changepassword'
  get 'student/upgradepassword', to: 'student#upgradepassword', as: 'student_upgradepassword'
  get 'student/profile', to: 'student#profile', as: 'student_profile'

  delete "student/checklogout", to: "student#checklogout", as: 'student_checklogout'
  post 'student/checklogin', to: 'student#checklogin', as: 'student_checklogin'
  get 'student/grades', to: 'student#grades', as: 'student_grades'
  get 'student/news', to: 'student#news', as: 'student_news'
  get 'student/notes', to: 'student#notes', as: 'student_notes'

  get 'student/absence', to: 'student#absence', as: 'student_absence'
  post 'student/justify', to: 'student#justify', as: 'student_justify'
  post 'student/justify_note', to: 'student#justify_note', as: 'student_justify_note'

  get 'student/homework', to: 'student#homework', as: 'student_homework'
  post 'student/submit', to: 'student#submit', as: 'student_submit'





  #family
  get 'family/login', to: 'family#login', as: 'family_login'
  get 'family/home', to: 'family#home', as: 'family_home'

  delete "family/checklogout", to: "family#checklogout", as: 'family_checklogout'
  post 'family/checklogin', to: 'family#checklogin', as: 'family_checklogin'

  get 'family/choose_student', to: 'family#choose_student', as: 'family_choose'
  get 'family/grades', to: 'family#grades', as: 'family_grades'
  get 'family/meeting_choice', to: 'family#meeting_choice', as: 'family_meeting_choice'
  get 'family/meeting_manage', to: 'family#meeting_manage', as: 'family_meeting_manage'
  post 'family/add_family_meeting', to: 'family#add_family_meeting', as: 'add_family_meeting'
  get 'family/absences', to: 'family#absences', as: 'family_absences'
  get 'family/news', to: 'family#news', as: 'family_news'
  delete "family/delete_meeting", to: "family#delete_meeting", as: 'delete_family_meeting'
  post 'family/justify', to: 'family#justify', as: 'family_justify'
  get 'family/popup', to: 'family#popup', as: 'family_popup'
  get 'family/notes', to: 'family#notes', as: 'family_notes'
  get 'family/profile', to: 'family#profile', as: 'family_profile'
  post 'family/changepassword', to: 'family#changepassword', as: 'family_changepassword'
  get 'family/upgradepassword', to: 'family#upgradepassword', as: 'family_upgradepassword'
  post 'family/justify_note', to: 'family#justify_note', as: 'family_justify_note'





#school_staff
get 'school_staff/login', to: 'school_staff#login', as: 'school_staff_login'
get 'school_staff/home', to: 'school_staff#home', as: 'school_staff_home'
get 'school_staff/staffManage', to: 'school_staff#staff_manage', as: 'school_staff_manage'
post 'school_staff/staffInsert', to: 'school_staff#insert', as: 'school_staff_insert'
post 'school_staff/staffEdit', to: 'school_staff#edit', as: 'school_staff_edit'
post 'school_staff/staffFilter', to: 'school_staff#filter', as: 'school_staff_filter'
delete "school_staff/deleteStaff", to: "school_staff#delete", as: "school_staff_delete"
post "school_staff/update", to: "school_staff#update", as: "school_staffupdate"
delete "school_staff/checklogout", to: "school_staff#checklogout", as: 'school_staff_checklogout'
post 'school_staff/checklogin', to: 'school_staff#checklogin', as: 'school_staff_checklogin'
get 'school_staff/staffManageSchool', to: 'school_staff#class_manage', as: 'school_staff_class_manage'
get "school_staff/searchClass", to: "school_staff#search_class", as: "staff_searchclass"
delete "school_staff/deleteClass", to: "school_staff#delete_class", as: "school_staff_deleteclass"
post "school_staff/addClass", to: "school_staff#add_class", as: "school_staff_addclass"
post "school_staff/editClass", to: "school_staff#edit_class", as: "school_staff_editclass"
post "school_staff/removeStudent", to: "school_staff#remove_student", as: "school_staff_removestudent"
get 'school_staff/staffManageSubject', to: 'school_staff#subject_manage', as: 'school_staff_subject_manage'
post "school_staff/addSubject" ,to: 'school_staff#subject_add', as: 'school_staff_subject_add' 
post "school_staff/editSubject" ,to: 'school_staff#subject_edit', as: 'school_staff_subject_edit' 
get "school_staff/communications", to: "school_staff#communications", as: "school_staff_communications"
get "school_staff/searchCommunication", to: "school_staff#search_communication", as: "school_staff_search_communication"
delete "school_staff/deleteCommunication", to: "school_staff#delete_communication", as: "school_staff_delete_communication"
post "school_staff/addCommunication", to: "school_staff#add_communication", as: "school_staff_add_communication"
post "school_staff/subjectDelete", to: "school_staff#subject_delete", as: "school_staff_subject_delete"  
delete "school_staff/subjectDelete", to: "school_staff#subject_delete", as: "school_staff_subject_deletee"  
get "school_staff/subjectSearch",to: "school_staff#subject_search",as: "staff_searchsubject"
get "schoolStaff/timetable",to: "school_staff#timetable",as: "school_staff_timetable"
get "school_staff/timeTableSearch",to: "school_staff#search_time",as: "staff_searchtime"
get 'school_staff/profile', to: 'school_staff#profile', as: 'school_staff_profile'
post 'school_staff/changepassword', to: 'school_staff#changepassword', as: 'school_staff_changepassword'
get 'school_staff/upgradepassword', to: 'school_staff#upgradepassword', as: 'school_staff_upgradepassword'


  #admin
  get "/admin/signup", to: "admin#signup", as: 'admin_signup'
  get "admin/manage", to: "admin#manage", as: 'admin_manage'
  post "/admin/create", to: "admin#create", as: 'admin_create'
  get "admin/login", to: "admin#login", as: "admin_login"
  post "/admin/createSchool", to: "admin#create_school", as: 'admin_create_school'
  post "/admin/createStaff", to: "admin#create_staff", as: 'admin_create_staff'
  post "/admin/editSchool", to: "admin#edit_school", as: 'admin_edit_school'
  post "/admin/updateSchool", to: "admin#update_school", as: 'admin_update_school'
  delete "/admin/deleteSchool", to: "admin#delete_school", as: "admin_deleteschool"
  post "/admin/updateStaff", to: "admin#update_staff", as: "admin_updatestaff"
  delete "/admin/deleteStaff", to: "admin#delete_staff", as: "admin_deletestaff"

  delete "admin/checklogout", to: "admin#checklogout", as: 'admin_checklogout'
  post 'admin/checklogin', to: 'admin#checklogin', as: 'admin_checklogin'

  get "admin/searchSchool", to: "admin#search_school", as: "admin_searchschool"
  get "admin/searchStaff", to: "admin#search_staff", as: "admin_searchstaff"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # namespace :admin do
  #   resources :schools, only: [:new, :create, :destroy]
  # end
  # namespace :admin do
  #   resources :users
  # end
  
end
