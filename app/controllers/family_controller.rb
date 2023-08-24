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
    puts "home"
    puts params[:CF]
    puts params[:CFstudent]

    
  end

  def choose_student
    @family=Family.find_by(CF: params[:CF])
    puts "choose"
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

end