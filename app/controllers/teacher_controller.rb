require "google/apis/calendar_v3"
require "google/api_client/client_secrets.rb"

class TeacherController < ApplicationController
  before_action :check_cookies_login, except: [:login, :checklogin]
  $has_logged =false

  def login
    #cookies.delete(:teacher)
    session.delete(:CF)
    if session[:CF].present?
      @teacher=Teacher.find_by(CF: session[:CF])
      redirect_to teacher_home_url
    end
  end

  def upgradepassword
    @teacher=Teacher.find_by(CF: session[:CF])
    @teacher.update(password: $passk)
    redirect_to teacher_home_url
  end

  def changepassword
    @teacher=Teacher.find_by(CF: session[:CF])
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
    @teacher=Teacher.find_by(CF: session[:CF])
    @classrooms=[["Select a class",nil]]+Subject.where(CFprof: @teacher.CF).pluck(:class_code).uniq
    unless(@classrooms)
      flash[:alert]= "There aren't any classrooms for this teacher!"
      redirect_to teacher_home_url
    end
  end

  def checklogin
    @teacher = Teacher.find_by(mail: params[:mail])
    if @teacher && @teacher.password == params[:password]
      session[:CF]= @teacher.CF
      if @teacher.first_login == true
        @teacher.update(first_login: false)
        cookies[:teacher]=@teacher.CF
      end
      redirect_to teacher_home_url
      
    else
      redirect_to teacher_login_url
      flash[:alert] = 'Credenziali non valide.'
    end
  end

  def checklogout
    session.delete(:CF)
    session.delete(:teacher_code)
    redirect_to root_path
  end

  def profile
    @teacher = Teacher.find_by(CF: session[:CF])
  end

  def check_cookies_login
    unless session[:CF].present?
        redirect_to teacher_login_url, alert: "Effettua l'accesso per continuare."
    end
    
  end
  
  def classroom
    @teacher=Teacher.find_by(CF: session[:CF])
    @classname=params[:classroom]
    if @classname==""
      flash[:alert]="select a class!"
      redirect_to teacher_home_url
    end
    @subjects=Subject.where(CFprof: @teacher.CF, class_code: params[:classroom]).pluck(:name).uniq
  end

  def commitment
    @teacher=Teacher.find_by(CF: session[:CF])
    @teacher_true = Teacher.find_by(name: @teacher.name, surname: @teacher.surname, school_code: @teacher.school_code)
    @meeting = Meeting.where(CFprof: @teacher_true)
    $client_calendar= get_google_calendar_client(@teacher)
    #@calendar_list = $client_calendar.list_calendar_lists

    

    @event_list =$client_calendar.list_events('6fb8a61d5cfb51e60783c32a6eb22acfaf8de8c8126dc7dbabb7da7568a85cc7@group.calendar.google.com')
    #Controllo i meeting (se il mio server ne ha in più li metto su calendar, altrimenti li rimuovo da calendar):
    @meeting.each do |meet| 
      if !@event_list.items.any?{ |event| (event.summary == meet.title) &&(event.start.date_time+2.hour== meet.date)} 
        start_date = meet.date - 2.hour
        end_date = start_date + 1.hour
        event = Google::Apis::CalendarV3::Event.new({
          summary: meet.title,
          location: "Rome, italy",
          description: meet.link,
          start: {
            date_time: start_date.to_datetime.rfc3339,
            # date_time: '2019-09-07T09:00:00-07:00',
            time_zone: 'UTC',
          },
          end: {
            date_time: end_date.to_datetime.rfc3339,
            time_zone: 'UTC',
          },
          reminders: {
            use_default: false,
            overrides: [
              Google::Apis::CalendarV3::EventReminder.new(reminder_method:"popup", minutes: 10),
              Google::Apis::CalendarV3::EventReminder.new(reminder_method:"email", minutes: 20)
            ]
          },
          notification_settings: {
            notifications: [
                            {type: 'event_creation', method: 'email'},
                            {type: 'event_change', method: 'email'},
                            {type: 'event_cancellation', method: 'email'},
                            {type: 'event_response', method: 'email'}
                           ]
          }, 'primary': true
        })
        $client_calendar.insert_event('6fb8a61d5cfb51e60783c32a6eb22acfaf8de8c8126dc7dbabb7da7568a85cc7@group.calendar.google.com', event)
                 
      end 
    end       
    @event_list.items.each do |event|
      if event.summary.include?("Meeting con ")
        if  !@meeting.any?{|meet| meet.title == event.summary}
          $client_calendar.delete_event('6fb8a61d5cfb51e60783c32a6eb22acfaf8de8c8126dc7dbabb7da7568a85cc7@group.calendar.google.com',event.id)
        end
      end
    end
    @commitments = Commitment.where(CFprof:@teacher_true, type: "Commitment" )
    @commitments.each do |commit| 

      if !@event_list.items.any?{|event| event.summary == commit.title &&(event.start.date_time.to_date== commit.date.to_date)}
        commit.destroy
      end
    end
    @event_list.items.each do |event|

      if !event.summary.include?("Meeting con ")
        if  !@commitments.any?{|commit| commit.title == event.summary}
          start_time = event.start.date_time
          end_time =  event.end.date_time
          new_date = start_time
          time = end_time.hour - start_time.hour
          time = time.to_i
          for i in 1..time
            @commitment = Commitment.new(
              title: event.summary,
              date: new_date,
              type: 'Commitment',
              CFprof: @teacher_true.CF,
              school_code: @teacher_true.school_code)
            if @commitment
              @commitment.save
              #  puts("sas")
            end
            new_date += 1.hour
          end
        end
      end
    end  

  end

  def get_google_calendar_client(current_user)
    client = Google::Apis::CalendarV3::CalendarService.new
    return unless (current_user.present? && current_user.access_token.present? && current_user.refresh_token.present?)
    secrets = Google::APIClient::ClientSecrets.new({
      "web" => {
        "access_token" => current_user.access_token,
        "refresh_token" => current_user.refresh_token,
        "client_id" => ENV["GOOGLE_OAUTH_CLIENT_KEY"],
        "client_secret" => ENV["GOOGLE_OAUTH_CLIENT_SECRET"]
      }
    })
    begin
      client.authorization = secrets.to_authorization
      client.authorization.grant_type = "refresh_token"

      if !current_user.present?
        client.authorization.refresh!
        current_user.update_attributes(
          access_token: client.authorization.access_token,
          refresh_token: client.authorization.refresh_token,
          expires_at: client.authorization.expires_at.to_i
        ) 
      end
    rescue Google::Apis::AuthorizationError => e
      # L'access token o il refresh token sono scaduti o non validi
      flash[:error] = 'Your token has expired or is invalid. Please login again with Google.'
      redirect_to teacher_login_url
    rescue StandardError => e
      # Altri errori possono essere gestiti qui
      flash[:error] = 'An error occurred while connecting to Google Calendar.'
      redirect_to teacher_login_url
    end
    client
  end

  def managecommitment
    @warning = false
    title=params[:title]
    if title==""
      redirect_to teacher_commitment_url
      flash[:alert] = 'Missing the name.'
      return
    end
    date=params[:date]
    if date==""
      redirect_to teacher_commitment_url
      flash[:alert] = 'Missing the date.'
      return
    end
    hours=params[:hour]
    if hours==""
      redirect_to teacher_commitment_url
      flash[:alert] = 'Missing the duration.'
      return
    end
    hours = hours.to_i
    date = DateTime.parse(date)
    if date.minute != 0
      @warning = true
    end
    date= date.change(min: 0)
    @teacher=Teacher.find_by(CF: params[:CFprof])
    @teacher_true = Teacher.find_by(name: @teacher.name, surname: @teacher.surname, school_code: @teacher.school_code)
    start_date = date - 2.hour
    end_date = start_date + hours.hour
    event = Google::Apis::CalendarV3::Event.new({
      summary: title,
      location: "Rome, italy",
      description: "",
      start: {
        date_time: start_date.to_datetime.rfc3339,
        # date_time: '2019-09-07T09:00:00-07:00',
        time_zone: 'UTC',
      },
      end: {
        date_time: end_date.to_datetime.rfc3339,
        time_zone: 'UTC',
      },
      reminders: {
        use_default: false,
        overrides: [
          Google::Apis::CalendarV3::EventReminder.new(reminder_method:"popup", minutes: 10),
          Google::Apis::CalendarV3::EventReminder.new(reminder_method:"email", minutes: 20)
        ]
      },
      notification_settings: {
        notifications: [
                        {type: 'event_creation', method: 'email'},
                        {type: 'event_change', method: 'email'},
                        {type: 'event_cancellation', method: 'email'},
                        {type: 'event_response', method: 'email'}
                       ]
      }, 'primary': true
    }) 
    # puts("mimomimo")
    if $client_calendar
      $client_calendar.insert_event('6fb8a61d5cfb51e60783c32a6eb22acfaf8de8c8126dc7dbabb7da7568a85cc7@group.calendar.google.com', event)
      # puts("ciao")
      if !@warning
        flash[:notice] = 'Task was successfully added.'
      else
        flash[:warning] = "Minutes setted to 00 as per school policy"
      end
    else
      flash[:notice] = 'Error on adding the task.'
      return
    end
      
       # Utilizzo un oggetto DateTime per la data iniziale
    new_date = DateTime.parse(params[:date]).change(min: 0)
     
    # puts new_date
    num = params[:hour].to_i
    for i in 1..num
      puts new_date.inspect
     @commitment = Commitment.new(
       title: params[:title],
       date: new_date,
       type: 'Commitment',
       CFprof: @teacher_true.CF,
       school_code: params[:school_code])
     if @commitment
       @commitment.save
      #  puts("sas")
     end
     new_date += 1.hour
    end      
    redirect_to teacher_commitment_url
  end
  
  def meeting
    @teacher=Teacher.find_by(CF: session[:CF])
    @meetings=Meeting.where(CFprof: @teacher.CF).order(date: :asc)
    token=generate_token(@teacher.name)
    room="ssarekde"
    random_link = SecureRandom.hex(10) #creo una stringa random di 8 caratteri
    @link_teacher="http://localhost:8000/#{random_link}"
    

  end

  def generate_token(name)
      payload = {
        iss: 'localhost',
        room: name,
        exp: Time.now.to_i + 3600, # Scadenza del token (1 ora)
      }
      jwt = JWT.encode payload, 'la_tua_chiave_segreta', 'HS256'
      jwt
  end

  def requestmeeting
    @teacher=Teacher.find_by(CF: session[:CF])
    @classname=params[:classroom]
    @confirm=""
    if(params[:confirm].present?)
      @confirm="email inviata al genitore!"
    end
    @students= Student.where(student_class_code: @classname)
    
  end

  def insertmeeting
    if !params[:CFstudent].present?
      flash[:alert]="select a student"
      redirect_to teacher_requestmeeting_url(classroom: params[:class_code])
      return
    end
    
    if !params[:text].present?
      flash[:alert]="write text"
      redirect_to teacher_requestmeeting_url(classroom: params[:class_code])
      return
    end

    @confirm=""  
    cfstudent=params[:CFstudent]
    student=Student.find_by(CF: cfstudent)
    teacher=Teacher.find_by(CF: params[:CFprof])
    cfparent=FamilyStudent.where(CFstudent: cfstudent).pluck(:CFfamily).uniq
    @parent_mail=Family.where(CF: cfparent).pluck(:mail).uniq
    text=params[:text]
    MeetingMailer.meeting_request(@parent_mail,text, student, teacher).deliver_now
    redirect_to teacher_requestmeeting_url(classroom: params[:class_code], confirm: "conferma")
  end

  def timetable
    @classname=params[:classroom]
    @teacher=Teacher.find_by(CF: session[:CF])
    days = ['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY']
    hours = (1..6).to_a
    subjects = Subject.where('upper(class_code) = ? AND school_code = ?', @classname.upcase, @teacher.school_code).order(Arel.sql("CASE weekday
      WHEN 'MONDAY' THEN 1
      WHEN 'TUESDAY' THEN 2
      WHEN 'WEDNESDAY' THEN 3
      WHEN 'THURSDAY' THEN 4
      WHEN 'FRIDAY' THEN 5
      WHEN 'SATURDAY' THEN 6
    END")).pluck(:name, :weekday, :time)
    
    result = hours.map do |hour|
      days.map do |day|
        subject = subjects.find { |s| s[1] == day && s[2].to_i == hour }
        subject ? subject[0] : '-'
      end
    end
    
    @ret = result
    
    
    
    if @ret!=[]
      render "timetable"
    else
      @ret = "NOT_FOUND"
      render "timetable"
    end 
  end

  def grade
    @teacher=Teacher.find_by(CF: session[:CF])
    @classname=params[:classroom]
    @subjects= [["Subject", nil]]+Subject.where(CFprof: session[:CF], class_code: params[:classroom]).pluck(:name).uniq
    
    @students=Student.where(student_class_code: params[:classroom])
    @weekdays=[]
    @times=[]
    @weekday=""
    @subject=""
    @time="" 
    if(params[:subject].present?)

      @subject=Subject.where(CFprof: session[:CF], class_code: params[:classroom], name: params[:subject]).pluck(:name).uniq
      @weekdays=[["Select weekday", nil]]+Subject.where(CFprof: session[:CF], class_code: params[:classroom], name: params[:subject]).pluck(:weekday).uniq
      
      if(params[:weekday].present?)
        @weekday=Subject.where(CFprof: session[:CF], class_code: params[:classroom], name: params[:subject], weekday: params[:weekday]).pluck(:weekday).uniq
        @times=[["Select school hour", nil]]+Subject.where(CFprof: session[:CF], class_code: params[:classroom], name: params[:subject], weekday: params[:weekday]).pluck(:time).uniq
        if(params[:time].present?)
          @time=Subject.where(CFprof: session[:CF], class_code: params[:classroom], name: params[:subject], weekday: params[:weekday], time: params[:time]).pluck(:time).uniq
        end
      end
    end
    @grades =  Grade.where(CFprof: session[:CF], class_code: params[:classroom])
  end

  def insertgrade
    if !params[:subject_name].present?
      flash[:alert]="select a subject"
      redirect_to teacher_grade_url(classroom: params[:class_code])
      return
    end
    puts(params[:weekday])
    if params[:weekday]==""
      flash[:alert]="select a weekday"
      redirect_to teacher_grade_url(classroom: params[:class_code], subject: params[:subject_name])
      return
    end


    if params[:time]==""
      flash[:alert]="select class hour"
      redirect_to teacher_grade_url(classroom: params[:class_code], subject: params[:subject_name], weekday: params[:weekday])
      return
    end

    if !params[:value].present?
      flash[:alert]="select a grade value!"
      redirect_to teacher_grade_url(classroom: params[:class_code], subject: params[:subject_name], weekday: params[:weekday], time: params[:time])
      return
    end

    if !params[:date].present?
      flash[:alert]="select a date"
      redirect_to teacher_grade_url(classroom: params[:class_code], subject: params[:subject_name], weekday: params[:weekday], time: params[:time])
      return
    end

    if !params[:CFstudent].present?
      flash[:alert]="select a student"
      redirect_to teacher_grade_url(classroom: params[:class_code], subject: params[:subject_name], weekday: params[:weekday], time: params[:time])
      return
    end

    selected_weekday=params[:weekday]
    day= Date.parse(params[:date]).strftime('%A').upcase
    if day==selected_weekday
      cfstudente=params[:CFstudent].join
      @grade=Grade.new(CFprof: params[:CFprof], CFstudent: params[:CFstudent].join , date: params[:date], value: params[:value], weekday: params[:weekday], time: params[:time], subject_name: params[:subject_name], class_code: params[:class_code], school_code: params[:school_code])
      begin
        if @grade.save
          redirect_to teacher_grade_url(classroom: params[:class_code])
        else
          flash[:alert] = "error while saving grade"
          redirect_to teacher_grade_url(classroom: params[:class_code])
        end
      rescue ActiveRecord::RecordNotUnique => e
        flash[:alert] = "This grade is already inserted."
        redirect_to teacher_grade_url(classroom: params[:class_code])
      end
    else
      flash[:alert]="error weekday and date don't match"
      redirect_to teacher_grade_url(classroom: params[:class_code])
    end

    
  end

  def absence
    @teacher=Teacher.find_by(CF: session[:CF])
    @classname=params[:classroom]
    @subjects=[["Subject", nil]]+Subject.where(CFprof: session[:CF], class_code: params[:classroom]).pluck(:name).uniq
    @students=Student.where(student_class_code: params[:classroom])
    @weekdays=[]
    @weekday=""
    @time=""
    @subject=""
    @times=[]
    if(params[:subject].present?)
      @subject=Subject.where(CFprof: session[:CF], class_code: params[:classroom], name: params[:subject]).pluck(:name).uniq
      @weekdays=[["Select weekday", nil]]+Subject.where(CFprof: session[:CF], class_code: params[:classroom], name: params[:subject]).pluck(:weekday).uniq
      if(params[:weekday].present?)
        @weekday=Subject.where(CFprof: session[:CF], class_code: params[:classroom], name: params[:subject], weekday: params[:weekday]).pluck(:weekday).uniq
        @times=[["Select school hour", nil]]+Subject.where(CFprof: session[:CF], class_code: params[:classroom], name: params[:subject], weekday: params[:weekday]).pluck(:time).uniq
        if(params[:time].present?)
          @time=Subject.where(CFprof: session[:CF], class_code: params[:classroom], name: params[:subject], weekday: params[:weekday], time: params[:time]).pluck(:time).uniq
        end
      end
    end
    @absences =  Absence.where(CFprof: session[:CF], class_code: params[:classroom])
  end

  def insertabsence
    if !params[:subject_name].present?
      flash[:alert]="select a subject"
      redirect_to teacher_absence_url(classroom: params[:class_code])
      return
    end
    puts(params[:weekday])
    if params[:weekday]==""
      flash[:alert]="select a weekday"
      redirect_to teacher_absence_url(classroom: params[:class_code], subject: params[:subject_name])
      return
    end
    if params[:time]==""
      flash[:alert]="select class hour"
      redirect_to teacher_absence_url(classroom: params[:class_code], subject: params[:subject_name], weekday: params[:weekday])
      return
    end
    if !params[:date].present?
      flash[:alert]="select a date"
      redirect_to teacher_absence_url(classroom: params[:class_code], subject: params[:subject_name], weekday: params[:weekday], time: params[:time])
      return
    end

    if !params[:CFstudent].present?
      flash[:alert]="select a student"
      redirect_to teacher_absence_url(classroom: params[:class_code], subject: params[:subject_name], weekday: params[:weekday], time: params[:time])
      return
    end
    selected_weekday=params[:weekday]
    day= Date.parse(params[:date]).strftime('%A').upcase
    if day==selected_weekday
      cfstudente=params[:CFstudent].join
      @absence=Absence.new(CFprof: params[:CFprof], CFstudent: cfstudente, date: params[:date], justified: params[:justified], weekday: params[:weekday], time: params[:time], subject_name: params[:subject_name], class_code: params[:class_code], school_code: params[:school_code])
      begin
        if @absence.save
          redirect_to teacher_absence_url(classroom: params[:class_code])
        else
          flash[:alert] = "error while saving absence"
          redirect_to teacher_absence_url(classroom: params[:class_code])
        end
      rescue ActiveRecord::RecordNotUnique => e
        flash[:alert] = "This absence is already inserted."
        redirect_to teacher_absence_url(classroom: params[:class_code])
      end
    else
      flash[:alert]="error weekday and date don't match"
      redirect_to teacher_absence_url(classroom: params[:class_code])
    end
    
    # puts(cfstudente)
    
    
  end

  def note
    @teacher=Teacher.find_by(CF: session[:CF])
    @classname=params[:classroom]
    @students=Student.where(student_class_code: @classname)
    
    @notes=Note.where(CFprof: session[:CF])
  end
  
  def insertnote
    if !params[:CFstudent].present?
      flash[:alert]="select a student!"
      redirect_to teacher_note_url(classroom: params[:class_code])
      return
    end
    if !params[:date].present?
      flash[:alert]="select date!"
      redirect_to teacher_note_url(classroom: params[:class_code])
      return
    end
    if !params[:description].present?
      flash[:alert]="insert description!"
      redirect_to teacher_note_url(classroom: params[:class_code])
      return
    end
    @note=Note.new(CFprof: params[:CFprof], CFstudent: params[:CFstudent].join, date: DateTime.parse(params[:date]), description: params[:description], school_code: params[:school_code])
    if @note
      begin
        if @note.save
          redirect_to teacher_note_url(classroom: params[:class_code])
        else
          flash[:alert] = "error while saving note"
          redirect_to teacher_note_url(classroom: params[:class_code])
        end
      rescue ActiveRecord::RecordNotUnique => e
        flash[:alert] = "This note is already inserted."
        redirect_to teacher_note_url(classroom: params[:class_code])
      end
    else
      flash[:alert]="error during note creation"
      redirect_to teacher_note_url(classroom: params[:class_code])
    end
  end

  def homework
    @teacher=Teacher.find_by(CF: session[:CF])
    @classname=params[:classroom]
    @subjects=[["Subject", nil]]+Subject.where(CFprof: session[:CF], class_code: params[:classroom]).pluck(:name).uniq
    @subject=""
    if params[:subject_name].present?
      @subject=params[:subject_name]
    end
    @homeworks= Homework.where(CFprof: session[:CF], class_code: params[:classroom])
  end

  def managehomework
    if !params[:subject_name].present?
      flash[:alert]="insert subject!"
      redirect_to teacher_homework_url(classroom: params[:class_code])
      return
    end

    if !params[:date].present?
      flash[:alert]="select a date"
      redirect_to teacher_homework_url(classroom: params[:class_code], subject: params[:subject_name])
      return
    end

    if !params[:name].present?
      flash[:alert]="select a title for your assignment"
      redirect_to teacher_homework_url(classroom: params[:class_code], subject: params[:subject_name])
      return
    end

    if !params[:text].present?
      flash[:alert]="insert a text for your assignment"
      redirect_to teacher_homework_url(classroom: params[:class_code], subject: params[:subject_name])
      return
    end
    @subjects=Subject.where(CFprof: params[:CFprof], class_code: params[:class_code], name: params[:subject_name]).first
    weekday=@subjects.weekday
    time=@subjects.time
    @homework=Homework.new(CFprof: params[:CFprof],delivered: params[:delivered], date: params[:date], text: params[:text], name: params[:name], weekday: weekday, time: time, subject_name: params[:subject_name], class_code: params[:class_code], school_code: params[:school_code])
    begin
      if @homework.save
        redirect_to teacher_homework_url(classroom: params[:class_code])
      else
        flash[:alert] = "error while saving homework"
        redirect_to teacher_homework_url(classroom: params[:class_code])
      end
    rescue ActiveRecord::RecordNotUnique => e
      flash[:alert] = "This homework is already inserted."
      redirect_to teacher_homework_url(classroom: params[:class_code])
    end
  end

  def agenda
    @teacher=Teacher.find_by(CF: session[:CF])
    @classname=params[:classroom]
    @homeworks=Homework.where(school_code: @teacher.school_code, class_code: @classname)
    @communications=Communication.where(school_code: @teacher.school_code)
    @news = @communications.to_a + @homeworks.to_a
    @news=@news.sort_by(&:date).reverse
  end

 def communication
  @teacher=Teacher.find_by(CF: session[:CF])
  @classname=params[:classroom]
  @communications=Communication.where(school_code: @teacher.school_code)
 end
end