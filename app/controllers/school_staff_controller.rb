class SchoolStaffController < ApplicationController
  def login
    if cookies[:school_staff_info].present? && JSON.parse(cookies[:school_staff_info])["islogged"] == true
      @staff=SchoolStaff.find_by(mail: mail)
      redirect_to staff_home_url(CF: @staff.CF)
      redirect_to school_staff_home_url
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
    @staff = SchoolStaff.find_by(CF: "55")
    # togliere SchoolStaff
    @tipi = User.pluck(:type).uniq
    @classi = []
    if(params[:type].present?)
      @tipi = User.where(type: params[:type]).pluck(:type).uniq
      if(params[:type] == "Student")
        @classi = [["ClassRoom",nil]]+ClassRoom.where(school_code: @staff.school_code).pluck(:class_code).uniq
    
        if (params[:class].present?)
          @classi = ClassRoom.where(school_code: @staff.school_code, class_code: params[:class]).pluck(:class_code).uniq
          puts @classi.inspect + "ciao"
        end
      end
    end
  end
  def insert
    # @option="Insert"
    # @staff = SchoolStaff.find_by(CF: params[:CF])
    
 
    # @classes =[]

    # if(params[:type].present?)
    #         #rendi definitico type   
    #   @types = params[:type]
    #   render 'staff_manage'
    #   @classes = [["ClassRoom",nil]]+ClassRoom.where(school_code: @staff.school_code).pluck(:class_code).uniq
    #   if (params[:class].present?)
    #     @classes = ClassRoom.where(school_code: params[:school], class_code: params[:class]).pluck(:class_code).uniq
    #   end
    # end
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
    @user = User.find_by(type: params[:type], CF: params[:CF])
    if @user.destroy
      redirect_to "school_staff/staffManage", allow_other_host: true
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

end