class SchoolStaffController < ApplicationController
  def login
    if cookies[:school_staff_info].present? && JSON.parse(cookies[:school_staff_info])["islogged"] == true
      mail=JSON.parse(cookies[:school_staff_info])["mail"]
      @staff=SchoolStaff.find_by(mail: mail)
      redirect_to school_staff_home_url(CF: @staff.CF)
    end
  end

  def checklogin
    school_staff = SchoolStaff.find_by(mail: params[:mail])
    if school_staff && school_staff.password == params[:password]
      school_staff_info = { mail: school_staff.mail, islogged: true }
      cookies[:school_staff_info] = { value: school_staff_info.to_json, expires: 30.day.from_now }
      redirect_to school_staff_home_url(CF: school_staff.CF)
    else
      flash[:alert] = 'Credenziali non valide.'
      redirect_to school_staff_login_url
    end
  end

  def checklogout
    cookies.delete(:school_staff_info)
    redirect_to root_path
  end

  def upgradepassword
    @staff=SchoolStaff.find_by(CF: params[:CF])
    @staff.update(password: $passk)
    redirect_to school_staff_home_url(CF: @staff.CF)
  end

  def changepassword
    @staff=SchoolStaff.find_by(CF: params[:CF])
    pass=params[:old_password]
    $passk=params[:password]
    if(@staff) && @staff.password == pass
      PasswordMailer.email_confirm(@staff).deliver_now
    else
      redirect_to school_staff_login_url
      flash[:alert]= "password inserita errata"
    end
    pass=""
  end
  
  def profile
    @staff = SchoolStaff.find_by(CF: params[:CF])
  end


  def staff_manage
    @teachers = []
    @students = []
    @families = []

    $typo = params[:type]
    

    $classroom = params[:classroom]
    
    
    @staff = SchoolStaff.find_by(CF: params[:CF])
    @type = User.pluck(:type).uniq
    
      if(params[:account].present?)
        @typeName = params[:account]
        if @typeName == "Teacher"
          @teachers = Teacher.where(school_code: @staff.school_code).uniq

        elsif @typeName == "Student"
          @students = Student.where(school_code:@staff.school_code).uniq

        else
          @families = Family.where(school_code: @staff.school_code).uniq

        end
      end 
     
    
    @tipi = User.pluck(:type).uniq
    @classi = []
    
    if(params[:type].present?)
      if(params[:type] == "Student")
        @classi = [["Select a class",nil]]+ClassRoom.where(school_code: @staff.school_code).pluck(:class_code).uniq
        if (params[:class].present?)
          @classi = ClassRoom.where(school_code: @staff.school_code, class_code: params[:class]).pluck(:class_code).uniq
          
        end
      end
    end
  end
  def insert
    
    @staffs = SchoolStaff.find_by(CF: params[:CF])
    @name = params[:name]
    @surname = params[:surname]
    @CFis = params[:CFis]
    @mail = params[:mail]
    @password = params[:password]
    @birthdate = params[:birthdate]
    @family_CF = params[:family_CF]

    if($typo=="Teacher")
      Teacher.create(name: @name, surname: @surname, CF: @CFis, mail: @mail, password: @password, school_code:  @staffs.school_code)
    elsif($typo=="Family")
      Family.create(name: @name, surname: @surname, CF: @CFis, school_code: @staffs.school_code, mail: @mail, password: @password)
      if(Student.where(CF: @CFis).present?)
        FamilyStudent.create(CFfamily: @family_CF, CFstudent: @CFis, school_code: @staffs.school_code)
      end
    elsif($typo == "Student")
      
      Student.create(name: @name, surname: @surname, CF: @CFis, mail: @mail, password: @password, school_code: @staffs.school_code, birthdate: @birthdate, student_class_code: $classroom, student_school_code: @staffs.school_code)
    end
  end
  def filter
    @type = params[:account]
    @option = "Filter"
    if @type == "Teacher"
      @teachers = Teacher.where(school_code: "1").uniq
      render 'staff_manage'
      
    elsif @type == "Student"
      @students = Student.where(school_code: "1").uniq
      render 'staff_manage'
      

    else
      @families = Family.where(school_code: "1").uniq
      render 'staff_manage'
      
    end  
  end
  def delete
    @school_code = User.where(CF: params[:CF]).pluck(:school_code).uniq
    @commitment = Commitment.where(school_code: @school_code)
    @commitment.delete_all
    @homework = Homework.where(school_code: @school_code)
    @homework.delete_all
    @grade = Grade.where(school_code: @school_code)
    @grade.delete_all
    @absence = Absence.where(school_code: @school_code)
    @absence.delete_all
    @note = Note.where(school_code: @school_code)
    @note.delete_all
    @subject = Subject.where(school_code: @school_code)
    @subject.delete_all
    @communication = Communication.where(school_code: @school_code)
    @communication.delete_all
    @familystudent = FamilyStudent.where(school_code: @school_code)
    @familystudent.delete_all
    @user = User.find_by(type: params[:type1], CF: params[:CF1])
    if @user.destroy
      redirect_to school_staff_manage_path(CF: params[:CF]), allow_other_host: true
    else
      render 'delete'
    end
  end
  def update
    @type = params[:type]
    if @type == "not_student"
      @user = User.find(params[:key])
      if @user.update_attribute(:mail, params[:mail])
        redirect_to "school_staff/staffManage", allow_other_host: true
      
      else
        render "edit"
      end
    elsif @type == "student"
      @student = Student.find(params[:key])
      if params[:old_class]!= params[:class]
        @absence = Absence.where(class_code: params[:old_class], CFstudent: params[:key])
        @absence.delete_all
        @grade = Grade.where(class_code: params[:old_class], CFstudent: params[:key])
        @grade.delete_all
        @student.update_attribute(:student_class_code, params[:class])
      end
      if @student.update_attribute(:mail, params[:mail])
        redirect_to "school_staff/staffManage", allow_other_host: true
      
      else
        render "edit"
      end
    end
  end



  def class_manage
    @classes = ClassRoom.where(school_code: params["CF"])
    @school = User.where(CF: params[:CF]).pluck(:school_code)
  end

  def search_class
    if params[:search]==""
      return
    end
    @ret_class = ClassRoom.where('lower(class_code) = ? AND school_code = ?', params[:search].downcase, params[:school])

    if @ret_class.exists?
      render "class_manage"
    else
      @ret_class = "NOT_FOUND"
      render "class_manage"
    end
  end
  def delete_class
    @old_class = params[:code]
    @school = User.where(CF: params[:CF]).pluck(:school_code).first
    @homework = Homework.where(class_code: @old_class, school_code: @school)
    @homework.delete_all
    @grade = Grade.where(class_code: @old_class, school_code: @school)
    @grade.delete_all
    @absence = Absence.where(class_code: @old_class, school_code: @school)
    @absence.delete_all
    @subject = Subject.where(class_code: @old_class, school_code: @school)
    @subject.delete_all
    @all_stud = Student.where(student_class_code: @old_class, school_code: @school)
    if @all_stud.exists?
      @all_stud.each do |stud|          
        @note = Note.where(CFstudent: stud.CF)
        @note.delete_all
        @fmst = FamilyStudent.where(CFstudent: stud.CF)
        @fmst.delete_all
        stud.destroy
      end
    end
    @class_room = ClassRoom.where(class_code: @old_class, school_code: @school)
    @class_room.delete_all
    redirect_to school_staff_class_manage_path(CF: params[:CF])
  end
  def add_class
    @school = User.where(CF: params[:CF]).pluck(:school_code).uniq.first
    @new_class = params[:class_code].upcase
    if ClassRoom.where(school_code: @school, class_code: @new_class).exists?
      redirect_to school_staff_class_manage_path(CF: params[:CF])
      flash[:alert]= "Classroom already present in the system"
    else
      if ClassRoom.create(school_code: @school, class_code: @new_class)
        redirect_to school_staff_class_manage_path(CF: params[:CF])
      else
        redirect_to school_staff_class_manage_path(CF: params[:CF])
        flash[:alert]= "Error Classroom creation"
      end
    end
  end

  def communications
    
  end
  def search_communication
    @ret_comm = Communication.where('lower(title) = ? AND school_code = ?', params[:search].downcase, params[:school])
    
    if @ret_comm.exists?
      render "communications"
    else
      @ret_comm = "NOT_FOUND"
      
      redirect_to school_staff_communications_path(CF: params[:CF])
      flash[:alert]= "Communication not found"
      return
    end
  end
  

  def delete_communication
    @cm = Communication.find_by(title: params[:title], school_code: params[:school])
    if @cm.destroy
      redirect_to school_staff_communications_path(CF: params[:CF]), allow_other_host: true
    else
      render 'delete'
    end
  end

  def add_communication
    @cd = User.where(CF: params[:CF]).pluck(:school_code).uniq.first
    @title = params[:title]
    @date = params[:date]
    @text = params[:text]
  
    @com = Communication.create(title: @title, text: @text, date: @date, school_code: @cd)
    if @com.save
      redirect_to school_staff_communications_path(CF: params[:CF])
    else
      redirect_to school_staff_communications_path(CF: params[:CF])
      flash[:alert]= "Error Creation"
    end
  end
  

  def edit_class
    @school = User.where(CF: params[:key]).pluck(:school_code).uniq.first
    @old_class = params[:old_class].upcase
    @new_class = params[:new_class].upcase
    if @new_class!=@old_class
      if !ClassRoom.where(school_code: @school, class_code: @new_class).exists?
        @homework = Homework.where(class_code: @old_class, school_code: @school)
        @homework.delete_all
        @grade = Grade.where(class_code: @old_class, school_code: @school)
        @grade.delete_all
        @absence = Absence.where(class_code: @old_class, school_code: @school)
        @absence.delete_all
        @subject = Subject.where(class_code: @old_class, school_code: @school)
        @subject.delete_all
        @all_stud = Student.where(student_class_code: @old_class, school_code: @school)
        if @all_stud.exists?
          @all_stud.each do |stud|          
            @note = Note.where(CFstudent: stud.CF)
            @note.delete_all
            stud.update_attribute(:student_class_code, @new_class)
          end
        end
        @classroom = ClassRoom.find_by(class_code: @old_class, school_code: @school)
        if @classroom.update(class_code: @new_class)
          redirect_to school_staff_class_manage_path(CF: params[:key])
        
        else
          redirect_to school_staff_class_manage_path(CF: params[:key])
          flash[:alert]= "Update errror"
        end
      else
        redirect_to school_staff_class_manage_path(CF: params[:key])
        flash[:alert]= "Classroom already present in the system"
      end
    end
    return
  end

  def remove_student
    @school = User.where(CF: params[:CF]).pluck(:school_code).uniq.first
    @grade = Grade.where(CFstudent: params[:stud], school_code: @school)
    @grade.delete_all
    @absence = Absence.where(CFstudent: params[:stud], school_code: @school)
    @absence.delete_all

    @student = Student.find_by(CF: params[:stud])
    if @student.update(student_class_code: "STUDENTS_WITHOUT_CLASS")
      redirect_to school_staff_class_manage_path(CF: params[:CF])
    end
  end
  def subject_manage
    
  end
  def subject_add
    @school = User.where(CF: params[:CF]).pluck(:school_code).uniq.first
    @cls = params[:subject_class].upcase
    if !ClassRoom.find_by(school_code: @school, class_code: @cls)
      redirect_to school_staff_subject_manage_path(CF: params[:CF])
      flash[:alert]= "Class not found"
      return
    end
    @teacher = params[:subject_teacher]
    if !Teacher.where(CF: @teacher).exists?
      redirect_to school_staff_subject_manage_path(CF: params[:CF])
      flash[:alert]= "Teacher not found"
      return
    end  
    @day = params[:subject_day].upcase
    @hour = params[:subject_hour]
    @name=params[:subject_name].downcase
    if Subject.where(school_code: @school, class_code: @cls, CFprof: @teacher, weekday: @day,time:@hour,name:@name).exists?
      redirect_to school_staff_subject_manage_path(CF: params[:CF])
      flash[:alert]= "Subject already added"
      return
    end
    @subj = Subject.new(school_code: @school, class_code: @cls, CFprof: @teacher, weekday: @day,time:@hour,name:@name)
    if @subj.save
      redirect_to school_staff_subject_manage_path(CF: params[:CF])
      return
    else
      redirect_to school_staff_subject_manage_path(CF: params[:CF])
      flash[:alert]= "Error add a new Subject"
    end
  end
  def subject_delete
    @school = User.where(CF: params[:CF]).pluck(:school_code).uniq.first
    @time = params[:subj_time]
    @day = params[:subj_day]
    @subj_name = params[:subj_name]
# se lo apro dal popup gli mando anche giorno e ora, se non è l'unica entry allora la elimino
    if @time.present? && @day.present?
      @cls = params[:subj_class]
      @prof = params[:subj_teacher]
      @subj = Subject.where(school_code:@school, class_code: @cls, CFprof: @prof, name: @subj_name)
      if @subj.count>1
        @subj = Subject.where(school_code:@school, class_code: @cls, time: @time, weekday: @day, CFprof: @prof,name: @subj_name)
        @subj.delete_all
        redirect_to school_staff_subject_manage_path(CF: params[:CF])
        return
      else
        @cls = params[:subj_class]
        @prof = params[:subj_teacher]
        
        @homework = Homework.where(class_code: @cls, school_code: @school, CFprof: @prof, subject_name: @subj_name )
        @homework.delete_all
        @grade = Grade.where(class_code: @cls, school_code: @school, CFprof: @prof, subject_name: @subj_name )
        @grade.delete_all
        @absence = Absence.where(class_code: @cls, school_code: @school, CFprof: @prof, subject_name: @subj_name )
        @absence.delete_all
        @subj = Subject.where(school_code:@school, class_code: @cls,CFprof: @prof,name: @subj_name)
        @subj.delete_all
        redirect_to school_staff_subject_manage_path(CF: params[:CF])
        return
      end
    # se invece lo apro dal menu principale oppure se è l'unica, debbo eliminare tutti i record associati
    else
      @cls = params[:subj_class]
      @prof = params[:subj_teacher]
      
      @homework = Homework.where(class_code: @cls, school_code: @school, CFprof: @prof, subject_name: @subj_name )
      @homework.delete_all
      @grade = Grade.where(class_code: @cls, school_code: @school, CFprof: @prof, subject_name: @subj_name )
      @grade.delete_all
      @absence = Absence.where(class_code: @cls, school_code: @school, CFprof: @prof, subject_name: @subj_name )
      @absence.delete_all
      @subj = Subject.where(school_code:@school, class_code: @cls,CFprof: @prof,name: @subj_name)
      @subj.delete_all
      redirect_to school_staff_subject_manage_path(CF: params[:CF])
      return
    end
  end
  def subject_edit
    @school = User.where(CF: params[:CF]).pluck(:school_code).uniq.first
    @subj_name = params[:subj_name]
    @cls = params[:subj_class]
    @old_prof = params[:subj_old_teacher]
    @new_prof = params[:subj_new_teacher]
    if @old_prof!= @new_prof
      @subj = Subject.where(school_code:@school, class_code: @cls,CFprof: @old_prof,name: @subj_name)
      if !Teacher.find_by(CF: @new_prof).exists?
        redirect_to school_staff_subject_manage_path(CF: params[:CF])
        flash[:alert]= "Error: Teacher not found"
        return
      end
      if @subj.update_all(CFprof: @new_prof)
        redirect_to school_staff_subject_manage_path(CF: params[:CF])
      else
        redirect_to school_staff_subject_manage_path(CF: params[:CF])
        flash[:alert]= "Error on change"
        return
      end
    end
  end
  def subject_search
    if params[:search]==""
      return
    end
    @ret_sub = Subject.where('lower(name) = ? AND school_code = ?', params[:search].downcase, params[:school]).order(:class_code).pluck(:name, :class_code, :CFprof).uniq
    if @ret_sub!=[]
      
      render "subject_manage"
    else
      @ret_sub = "NOT_FOUND"
      render "subject_manage"
    end
  end
  def timetable
  end
  def search_time
    days = ['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY']
    hours = (1..6).to_a
    subjects = Subject.where('upper(class_code) = ? AND school_code = ?', params[:search].upcase, params[:school]).order(Arel.sql("CASE weekday
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
end