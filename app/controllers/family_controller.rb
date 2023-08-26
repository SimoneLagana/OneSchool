class FamilyController < ApplicationController
  before_action :check_cookies_login, except: [:login, :checklogin]

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
      redirect_to family_choose_url(CF: @family.CF)
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
    puts "choose"
  end

  def meeting_choice
    @family=Family.find_by(CF: params[:CF])
    @student=Student.find_by(CF: params[:CFstudent])
    puts "home"
    puts params[:CF]
    puts params[:CFstudent]
  end

  def meeting_manage
    @family=Family.find_by(CF: params[:CF])
    @student=Student.find_by(CF: params[:CFstudent])
    @teacher=Teacher.find_by(CF: params[:CFteacher])
    
    @start_hour = 16
    @end_hour = 19
    @today = Date.today
    @time_slots = []

    # Crea un elenco di tutti i giorni della prossima settimana per ogni ora nell'intervallo
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
      puts @my_iso
      @iso_meeting << @my_iso
    end
  end

 def create_link(teacher)
    random_link = SecureRandom.hex(4) #creo una stringa random di 8 caratteri
    link="https://localhost:8000/#{random_link}?teacher=#{teacher.surname}"
  end

 

  def add_family_meeting
    # @day = params[:day]
    # @month = params[:month]
    # @time = params[:time]
    @teacher = Teacher.find_by(CF: params[:CFprof])
    @title = "Meeting con " + @teacher.name + " " + @teacher.surname
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
    puts "grades"
    puts @family.CF
  end

  def absences
    @family=Family.find_by(CF: params[:CF])
    @student=Student.find_by(CF: params[:CFstudent])
    @absences=Absence.where(CFstudent: @student.CF)
    puts "grades"
    puts @family.CF
  end

  def news
    @family=Family.find_by(CF: params[:CF])
    @student=Student.find_by(CF: params[:CFstudent])
    @news=Communication.all
  end

  def justify
    @family=Family.find_by(CF: params[:CF])
    @student=Student.find_by(CF: params[:CFstudent])
    @absence=
    @ab = Absence.find_by(CFstudent: params[:CFstudent], date: params[:date], CFprof: params[:teach])
    @ab.update(justified: true)
    puts "Aggiornamento riuscito"
    
    puts "Aggiornamento non riuscito"
    puts @ab.errors.full_messages # Stampa eventuali messaggi di errore
    end
        
  end

  def notes
    @student=Student.find_by(CF: params[:CFstudent])
    @notes = Note.where(CFstudent: params[:CFstudent])
  end

end