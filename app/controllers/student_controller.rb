class StudentController < ApplicationController
  before_action :check_cookies_login, except: [:login, :checklogin]

  def login
    if cookies[:student_info].present? && JSON.parse(cookies[:student_info])["islogged"] == true
      mail=JSON.parse(cookies[:student_info])["mail"]
      @student=Student.find_by(mail: mail)
      redirect_to student_home_url(CF: @student.CF)
    end
    
  end

  def checklogin
    @student = Student.find_by(mail: params[:mail])
    if @student && @student.password == params[:password]
      student_info = { mail: @student.mail, islogged: true }
      cookies[:student_info] = { value: student_info.to_json, expires: 30.day.from_now }
      redirect_to student_home_url(CF: @student.CF)
    else
      redirect_to student_login_url
      flash[:alert] = 'Credenziali non valide.'
      
    end
  end

  def checklogout
    cookies.delete(:student_info)
    redirect_to root_path
  end

  def home
    @student=Student.find_by(CF: params[:CF])
  end

  def news
    @student=Student.find_by(CF: params[:CF])
    @news=Communication.all
  end

  def check_cookies_login
    unless cookies[:student_info].present?
        redirect_to student_login_url, alert: "Effettua l'accesso per continuare."
    end
    
  end

  def grades
    @student=Student.find_by(CF: params[:CFstudent])
  end

  def notes
    @notes = Note.where(CFstudent: params[:CFstudent])
  end

end