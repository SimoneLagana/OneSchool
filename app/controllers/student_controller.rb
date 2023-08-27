class StudentController < ApplicationController
  before_action :check_cookies_login, except: [:login, :checklogin]
  before_action :ofAge, except: [:login, :checklogin, :logout, :checklogout]
  $ofAge = false

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
    @student=Student.find_by(CF: params[:CF])
    @notes = Note.where(CFstudent: params[:CF])
  end


  def justify_note
    @student=Student.find_by(CF: params[:CF])

    @note= Note.find_by(id: params[:id])

    @note.update(justified: true)
    redirect_to student_notes_url(CF: params[:CF])
    
  end

  def absence
    @student=Student.find_by(CF: params[:CF])
    @absences=Absence.where(CFstudent: @student.CF)
    puts $ofAge
  end

  def ofAge
    @student = Student.find_by(CF: params[:CF])
    @birth = @student.birthdate
    puts @birth
    @today = DateTime.now.in_time_zone("UTC")
    puts @today

    @diff_sec = @today - @birth
    puts @diff_sec

    @diff_days = @diff_sec / 86400
    @diff_years = @diff_days / 365.25

    if @diff_years > 18
      $ofAge = true
    else
      $ofAge = false
    end 
  end

  
  def justify
    @student=Student.find_by(CF: params[:CF])
    @date = params[:date]
    @d = DateTime.parse(@date).utc

     @absence= Absence.find_by(CFstudent: params[:CF], school_code: params[:school_code], 
            class_code: params[:class_code], weekday: params[:weekday], time: params[:time], date: @date)
    
    @absence.update(justified: true)
    redirect_to student_absence_url(CF: params[:CF])
    
  end

end