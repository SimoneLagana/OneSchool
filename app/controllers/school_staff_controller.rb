class SchoolStaffController < ApplicationController
  def login
    if cookies[:school_staff_info].present? && JSON.parse(cookies[:school_staff_info])["islogged"] == true
      redirect_to school_staff_home_url
    end
  end

  def checklogin
    school_staff = SchoolStaff.find_by(mail: params[:mail])
    if school_staff && school_staff.password == params[:password]
      school_staff_info = { mail: school_staff.mail, islogged: true }
      cookies[:school_staff_info] = { value: school_staff_info.to_json, expires: 30.day.from_now }
      redirect_to school_staff_home_url
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
    @types= []
    @schools=[]
    @classes = []

    @staff = SchoolStaff.find_by(CF: "55")
  end
  def insert

    @staff = SchoolStaff.find_by(CF: params[:CF])
    
 
    @classes =[]

    if(params[:type].present?)
            #rendi definitico type   
      @types = params[:type]
      render 'staff_manage'
      @classes = [["ClassRoom",nil]]+ClassRoom.where(school_code: @staff.school_code).pluck(:class_code).uniq
      if (params[:class].present?)
        @classes = ClassRoom.where(school_code: params[:school], class_code: params[:class]).pluck(:class_code).uniq
      end
    end
  end  
end