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

  def staff_manage
    # @types= ["Teacher","Student","Family"]
    # @schools=[]
    # @classes = []
    # @option="index"
    # @type=""
    # @staff = SchoolStaff.find_by(CF: "55")
    @teachers = []
    @students = []
    @families = []

    $typo = params[:type]
    puts $typo

    $classroom = params[:classroom]
    puts $classroom
    
    @staff = SchoolStaff.find_by(CF: params[:CF])
    @type = User.pluck(:type).uniq
    @typeName = "Teacher"
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
    # togliere SchoolStaff
    @tipi = User.pluck(:type).uniq
    @classi = []
    
    if(params[:type].present?)
      #@tipi = User.where(type: params[:type]).pluck(:type).uniq
      if(params[:type] == "Student")
        @classi = [["Select a class",nil]]+ClassRoom.where(school_code: @staff.school_code).pluck(:class_code).uniq
        if (params[:class].present?)
          @classi = ClassRoom.where(school_code: @staff.school_code, class_code: params[:class]).pluck(:class_code).uniq
          
        end
      end
    end
  end
  def insert
    puts $typo
    puts $classroom
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
    elsif($typo == "Student")
      puts "ciao!"
      Student.create(name: @name, surname: @surname, CF: @CFis, mail: @mail, password: @password, school_code: @staffs.school_code, birthdate: @birthdate, student_class_code: $classroom, student_school_code: @staffs.school_code)
    end
  end
  def filter
    @type = params[:account]
    @option = "Filter"
    if @type == "Teacher"
      @teachers = Teacher.where(school_code: "1").uniq
      render 'staff_manage'
      puts @teachers.inspect
    elsif @type == "Student"
      @students = Student.where(school_code: "1").uniq
      render 'staff_manage'
      puts @students.inspect

    else
      @families = Family.where(school_code: "1").uniq
      render 'staff_manage'
      puts @families.inspect
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
    @school = User.where(CF: params[:CF]).pluck(:school_code)
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
    redirect_to "school_staff/staffManageSchool",allow_other_host: true
  end
  def add_class
    
  end
  def edit_class
    @school = User.where(CF: params[:key]).pluck(:school_code).uniq
    @old_class = params[:old_class]
    @new_class = params[:new_class]
    if(@new_class!=@old_class)
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
      @classroom = ClassRoom.where(class_code: @old_class, school_code: @new_class)
      if @classroom.update_attribute(:class_code, @new_class)
        redirect_to "school_staff/staffManage", allow_other_host: true
      end
    end
  end  
end