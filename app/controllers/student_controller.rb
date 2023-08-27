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

  
  def upgradepassword
    @student=Student.find_by(CF: params[:CF])
    @student.update(password: $passk)
    redirect_to student_home_url(CF: @student.CF)
  end

  def changepassword
    @student=Student.find_by(CF: params[:CF])
    pass=params[:old_password]
    $passk=params[:password]
    if(@student) && @student.password == pass
      PasswordMailer.email_confirm(@student).deliver_now
    else
      redirect_to student_login_url
      flash[:alert]= "password inserita errata"
    end
    pass=""
  end
  
  def profile
    @student = Student.find_by(CF: params[:CF])
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

  def homework
    @subject= []
    @student=Student.find_by(CF: params[:CF])
    @homeworks =Homework.where(class_code: @student.student_class_code, school_code: @student.school_code, delivered: false)
    @submitted_homeworks= Homework.where(class_code: @student.student_class_code, school_code: @student.school_code, delivered: true)
    puts(@student.student_class_code)
    puts("ciao")
    @subjects= [["Subject", nil]]+Subject.where(class_code: @student.student_class_code, school_code: @student.school_code).pluck(:name).uniq
    if(params[:subject].present?)
      @subject= params[:subject]
      @homeworks =Homework.where(class_code: @student.student_class_code, school_code: @student.school_code, subject_name: @subject, delivered: false)
      @submitted_homeworks= Homework.where(class_code: @student.student_class_code, school_code: @student.school_code, subject_name: @subject, delivered: true)
    end
  end

  def submit
    @student=Student.find_by(CF:params[:CF])
    names=params[:other]
    student_name= @student.name + @student.surname + names
    @text = params[:mail_text]
    @teacher=Teacher.find_by(CF: params[:CFprof])
    puts(@teacher.mail)
    @homework=Homework.find_by(CFprof: @teacher.CF, school_code: @student.school_code, class_code: @student.student_class_code, date: params[:date], weekday: params[:weekday], time: params[:time], subject_name: params[:subject_name])
    @homework.delete

    @homework=Homework.create(CFprof: @teacher.CF, school_code: @student.school_code, class_code: @student.student_class_code, date: params[:date], weekday: params[:weekday], time: params[:time], subject_name: params[:subject_name], delivered: true)
    @homework.file.attach(params[:file])
    @homework.save
    SubmitMailer.submit_homework(@teacher, student_name, @text, @homework).deliver_now
    @homework.update(delivered: true)
    if (params[:subject].present?)
      redirect_to student_homework_url(CF: @student.CF, subject: params[:subject])
    else
      redirect_to student_homework_url(CF: @student.CF)
    end
  end

end