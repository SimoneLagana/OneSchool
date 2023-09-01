class FamilyController < ApplicationController
  before_action :check_cookies_login, except: [:login, :checklogin]
  before_action :onlyChild, except: [:login, :checklogin, :logout, :checklogout]
  $onlyChild = false

  def onlyChild
    @family = Family.find_by(CF: params[:CF])
    @studrel = FamilyStudent.where(CFfamily: @family.CF).distinct.pluck(:CFstudent)
    if @studrel.length > 1
      $onlyChild = false
    else 
      $onlyChild = true
    end
  end

  def login
    if cookies[:family_info].present? && JSON.parse(cookies[:family_info])["islogged"] == true
      mail=JSON.parse(cookies[:family_info])["mail"]
      @family=Family.find_by(mail: mail)
      redirect_to family_choose_url(CF: @family.CF)
    end
  end

  def checklogin
    @family = Family.find_by(mail: params[:mail])
    if @family && @family.password == params[:password]
      family_info = { mail: @family.mail, islogged: true }
      cookies[:family_info] = { value: family_info.to_json, expires: 30.day.from_now }
      @studrel = FamilyStudent.where(CFfamily: @family.CF).distinct.pluck(:CFstudent)
      if @studrel.length > 1
        redirect_to family_choose_url(CF: @family.CF)
      else
        @studentCF = @studrel[0]
        
        $onlyChild = true
        redirect_to family_home_url(CF: @family.CF, CFstudent: @studentCF)
      end
    else
      redirect_to family_login_url
      flash[:alert] = 'Credenziali non valide.'
      
    end
  end

  def checklogout
    cookies.delete(:family_info)
    redirect_to root_path
  end

  def home
    @family=Family.find_by(CF: params[:CF])
    @student=Student.find_by(CF: params[:CFstudent])
  end

  def choose_student
    @family=Family.find_by(CF: params[:CF])
    
  end

  def meeting_choice
    @family=Family.find_by(CF: params[:CF])
    @student=Student.find_by(CF: params[:CFstudent])
  end





  def meeting_manage
    @family=Family.find_by(CF: params[:CF])
    @student=Student.find_by(CF: params[:CFstudent])
    @teacher=Teacher.find_by(CF: params[:CFteacher])
    
    @start_hour = 16
    @end_hour = 19
    @today = Date.today
    @time_slots = []

   
    (@today..@today + 6).each do |day|
      (@start_hour..@end_hour).each do |hour|
        @iso = DateTime.new(day.year, day.month, day.day, hour, 0, 0, '+00:00')
        @utc_time = @iso.strftime("%Y-%m-%d %H:%M:%S %z")
        @time_slots << @utc_time
      end
    end

    
    @commit_datetime = Commitment.where(CFprof: params[:CFprof]).pluck(:date)
    @iso_commit = []

    @commit_datetime.each do |toiso|
        @iso = toiso.strftime("%Y-%m-%d %H:%M:%S %z")
        @iso_commit << @iso
    end

    @free_slots = @time_slots - @iso_commit
    @iso_meeting =[]

    @my_meeting = Meeting.where(CFprof: params[:CFprof]).where(CFfamily: params[:CF]).pluck(:date)
    @my_meeting.each do |toiso|
      @my_iso = toiso.strftime("%Y-%m-%d %H:%M:%S %z")
      
      @iso_meeting << @my_iso
    end
  end






 def create_link(teacher)
    random_link = SecureRandom.hex(10) 
    link="http://localhost:8000/#{random_link}"
  end

 

  def add_family_meeting
    
    @teacher = Teacher.find_by(CF: params[:CFprof])
    @family = Family.find_by(CF: params[:CF])
    @title = "Meeting con " + @family.name + " " + @family.surname
    @free = params[:free]
    @date = DateTime.parse(@free)
    @school_code = Teacher.find_by(CF: params[:CFprof]).school_code
    #genera link casuale
    meeting_link=create_link(@teacher)


    @meeting_par = {CFfamily: params[:CF], date: @date, CFprof: params[:CFprof], title: @title, link: meeting_link}

    @meeting = Meeting.new(@meeting_par)
    if @meeting.save
        redirect_to family_meeting_manage_url(CF: params[:CF], CFstudent: params[:CFstudent], CFprof: params[:CFprof])
    end
  end


    def delete_meeting
      @meeting = Meeting.find_by(CFprof: params[:CFprof], CFfamily: params[:CF], date: params[:meeting])
      @meeting.destroy
      redirect_to family_meeting_manage_url(CF: params[:CF], CFstudent: params[:CFstudent], CFprof: params[:CFprof])
    end


  def check_cookies_login
    unless cookies[:family_info].present?
        redirect_to family_login_url, alert: "Effettua l'accesso per continuare."
    end
  end

  def grades
    @family=Family.find_by(CF: params[:CF])
    @student=Student.find_by(CF: params[:CFstudent])
  end

  def absences
    @family=Family.find_by(CF: params[:CF])
    @student=Student.find_by(CF: params[:CFstudent])
    @absences=Absence.where(CFstudent: @student.CF)

  end

  def news
    @family=Family.find_by(CF: params[:CF])
    @student=Student.find_by(CF: params[:CFstudent])
    @news=Communication.all
  end

  def justify
    @family=Family.find_by(CF: params[:CF])
    @student=Student.find_by(CF: params[:CFstudent])
    @date = params[:date]
    @d = DateTime.parse(@date).utc

     @absence= Absence.find_by(CFstudent: params[:CFstudent], school_code: params[:school_code], 
            class_code: params[:class_code], weekday: params[:weekday], time: params[:time], date: @date
            )
    
    @absence.update(justified: true)
    redirect_to family_absences_url(CF: params[:CF], CFstudent: params[:CFstudent])
    
  end

  def notes
    @student=Student.find_by(CF: params[:CFstudent])
    @notes = Note.where(CFstudent: params[:CFstudent])
  end


  def justify_note
    @family=Family.find_by(CF: params[:CF])
    @student=Student.find_by(CF: params[:CFstudent])

    @note= Note.find_by(id: params[:id])

    @note.update(justified: true)
    redirect_to family_notes_url(CF: params[:CF], CFstudent: params[:CFstudent])
    
  end

  def profile
    @student=Student.find_by(CF: params[:CFstudent])
    @family=Family.find_by(CF: params[:CF])
  end


  def upgradepassword
    @family=Family.find_by(CF: params[:CF])
    @family.update(password: $passk)
    redirect_to family_home_url(CF: @family.CF)
  end

  def changepassword
    @family=Family.find_by(CF: params[:CF])
    pass=params[:old_password]
    $passk=params[:password]
    if(@family) && @family.password == pass
      PasswordMailer.email_confirm(@family).deliver_now
    else
      redirect_to family_login_url
      flash[:alert]= "password inserita errata"
    end
    pass=""
  end

  
end