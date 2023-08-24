class TeacherController < ApplicationController
  before_action :check_cookies_login, except: [:login, :checklogin]


  def login
    if cookies[:teacher_info].present? && JSON.parse(cookies[:teacher_info])["islogged"] == true
      mail=JSON.parse(cookies[:teacher_info])["mail"]
      @teacher=@teacher=Teacher.find_by(mail: mail)
      redirect_to teacher_home_url(CF: @teacher.CF)
    end
  end

  def upgradepassword
    @teacher=Teacher.find_by(CF: params[:CF])
    @teacher.update(password: $passk)
    redirect_to teacher_home_url(CF: @teacher.CF)
  end

  def changepassword
    @teacher=Teacher.find_by(CF: params[:CF])
    pass=params[:old_password]
    $passk=params[:password]
    if(@teacher) && @teacher.password == pass
      PasswordMailer.email_confirm(@teacher).deliver_now
    else
      redirect_to teacher_login_url
      flash[:alert]= "password inserita errata"
    end
    pass=""
  end
  
  def home
    @teacher=Teacher.find_by(CF: params[:CF])
    @classrooms=Subject.where(CFprof: @teacher.CF).pluck(:class_code).uniq
    unless(@classrooms)
      flash[:alert]= "non ci sono classi per questo insegnante, contatta la segreteria"
    end
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
  
  def classroom
    @teacher=Teacher.find_by(CF: params[:CF])
    @classname=params[:classroom]
    @subjects=Subject.where(CFprof: @teacher.CF, class_code: params[:classroom]).pluck(:name).uniq
  end

  def meeting
  end

  def grade
    @teacher=Teacher.find_by(CF: params[:CF])
    @classname=params[:classroom]
    @subjects=[["Subject", nil]]+Subject.where(CFprof: params[:CF], class_code: params[:classroom]).pluck(:name).uniq
    @students=Student.where(student_class_code: params[:classroom])
    @weekdays=[]
    @times=[]
    if(params[:subject].present?)
      @subjects=Subject.where(CFprof: params[:CF], class_code: params[:classroom], name: params[:subject]).pluck(:name).uniq
      @weekdays=[["Weekday", nil]]+Subject.where(CFprof: params[:CF], class_code: params[:classroom], name: params[:subject]).pluck(:weekday).uniq
      if(params[:weekday].present?)
        @weekdays=Subject.where(CFprof: params[:CF], class_code: params[:classroom], name: params[:subject], weekday: params[:weekday]).pluck(:weekday).uniq
        @times=[["Time", nil]]+Subject.where(CFprof: params[:CF], class_code: params[:classroom], name: params[:subject], weekday: params[:weekday]).pluck(:time).uniq
        if(params[:time].present?)
          @times=Subject.where(CFprof: params[:CF], class_code: params[:classroom], name: params[:subject], weekday: params[:weekday], time: params[:time]).pluck(:time).uniq
        end
      end
    end
    @grades =  Grade.where(CFprof: params[:CF], class_code: params[:classroom])
  end

  def insertgrade
    cfstudente=params[:CFstudent].join
    puts(cfstudente)
    @grade=Grade.new(CFprof: params[:CFprof], CFstudent: cfstudente, date: params[:date], value: params[:value], weekday: params[:weekday], time: params[:time], subject_name: params[:subject_name], class_code: params[:class_code], school_code: params[:school_code])
    if @grade
      @grade.save
      redirect_to teacher_grade_url(CF: params[:CFprof], classroom: params[:class_code])
    end
  end

  def absence
    @teacher=Teacher.find_by(CF: params[:CF])
    @classname=params[:classroom]
    @subjects=[["Subject", nil]]+Subject.where(CFprof: params[:CF], class_code: params[:classroom]).pluck(:name).uniq
    @students=Student.where(student_class_code: params[:classroom])
    @weekdays=[]
    @times=[]
    if(params[:subject].present?)
      @subjects=Subject.where(CFprof: params[:CF], class_code: params[:classroom], name: params[:subject]).pluck(:name).uniq
      @weekdays=[["Weekday", nil]]+Subject.where(CFprof: params[:CF], class_code: params[:classroom], name: params[:subject]).pluck(:weekday).uniq
      if(params[:weekday].present?)
        @weekdays=Subject.where(CFprof: params[:CF], class_code: params[:classroom], name: params[:subject], weekday: params[:weekday]).pluck(:weekday).uniq
        e@tims=[["Time", nil]]+Subject.where(CFprof: params[:CF], class_code: params[:classroom], name: params[:subject], weekday: params[:weekday]).pluck(:time).uniq
        if(params[:time].present?)
          @times=Subject.where(CFprof: params[:CF], class_code: params[:classroom], name: params[:subject], weekday: params[:weekday], time: params[:time]).pluck(:time).uniq
        end
      end
    end
    @absences =  Absence.where(CFprof: params[:CF], class_code: params[:classroom])
  end

  def insertabsence
    cfstudente=params[:CFstudent].join
    puts(cfstudente)
    @absence=Absence.new(CFprof: params[:CFprof], CFstudent: cfstudente, date: params[:date], justified: params[:justified], weekday: params[:weekday], time: params[:time], subject_name: params[:subject_name], class_code: params[:class_code], school_code: params[:school_code])
    if @absence
      @absence.save
      redirect_to teacher_absence_url(CF: params[:CFprof], classroom: params[:class_code])
    end
  end

  def note
    @teacher=Teacher.find_by(CF: params[:CF])
    @students=Student.where(student_class_code: params[:classroom])
    @classname=params[:classroom]
    @notes=Note.where(CFprof: params[:CF])
  end
  
  def insertnote
    @note=Note.new(CFprof: params[:CFprof], CFstudent: params[:CFstudent], date: params[:date], description: params[:description], school_code: params[:school_code])
    if @note
      @note.save
      redirect_to teacher_note_url(CF: params[:CFprof], classroom: params[:classroom])
    end
  end

  def homework
    @teacher=Teacher.find_by(CF: params[:CF])
    @classname=params[:classroom]
    @subjects=[["Subject", nil]]+Subject.where(CFprof: params[:CF], class_code: params[:classroom]).pluck(:name).uniq
    @homeworks= Homework.where(CFprof: params[:CF], class_code: params[:classroom])
  end

  def managehomework
    @subjects=Subject.where(CFprof: params[:CFprof], class_code: params[:class_code], name: params[:subject_name]).first
    weekday=@subjects.weekday
    time=@subjects.time
    @homework=Homework.new(CFprof: params[:CFprof],delivered: params[:delivered], date: params[:date], text: params[:text], name: params[:name], weekday: weekday, time: time, subject_name: params[:subject_name], class_code: params[:class_code], school_code: params[:school_code])
    if @homework
      @homework.save
      redirect_to teacher_homework_url(CF: params[:CFprof], classroom: params[:class_code])
    end
  end
end