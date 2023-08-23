class TeacherController < ApplicationController
  before_action :check_cookies_login, except: [:login, :checklogin]

  def login
    if cookies[:teacher_info].present? && JSON.parse(cookies[:teacher_info])["islogged"] == true
      mail=JSON.parse(cookies[:teacher_info])["mail"]
      @teacher=@teacher=Teacher.find_by(mail: mail)
      redirect_to teacher_home_url(CF: @teacher.CF)
    end
  end

  def changepassword
    @teacher =Teacher.find_by(mail: params[:mail])
    if(@teacher) && @teacher.password == params[:old_password]
      @teacher.password = params[:password]
    else
      flash[:alert] = 'Credenziali non valide.'
  end
  
  def home
    @teacher=Teacher.find_by(CF: params[:CF])
  end

  

  def checklogin
    @teacher = Teacher.find_by(mail: params[:mail])
    if @teacher && @teacher.password == params[:password]
      teacher_info = { mail: @teacher.mail, islogged: true }
      cookies[:teacher_info] = { value: teacher_info.to_json, expires: 30.day.from_now }
      redirect_to teacher_home_url(CF: @teacher.CF)
      
    else
      redirect_to teacher_login_url
      flash[:alert] = 'Credenziali non valide.'
    end
  end

  def checklogout
    cookies.delete(:teacher_info)
    redirect_to root_path
  end

  def profile
    @teacher = Teacher.find_by(CF: params[:CF])
  end

  def check_cookies_login
    unless cookies[:teacher_info].present?
        redirect_to teacher_login_url, alert: "Effettua l'accesso per continuare."
    end
    
  end
  
def ClassRoom
    puts "susine"
end

  #def accessclass
    #@teacher=Teacher.find_by(CF: params[:CF])
    #@class=ClassRoom.find_by(class_code: params[:class_code], school_code: params[:school_code])
    #if @class
    #  puts "ciao"
    #  redirect_to teacher_class_url(CF: @teacher.CF, class_code: @class.class_code)
    #else
    #  puts "not ciao"
    #end
  #end

end