class TeacherController < ApplicationController
  
  def login
    if cookies[:teacher_info].present? && JSON.parse(cookies[:teacher_info])["islogged"] == true
      redirect_to teacher_home_url
    end
  end

  def checklogin
    @teacher = Teacher.find_by(mail: params[:mail])
    puts @teacher
    puts "ajsjis"
    if @teacher && @teacher.password == params[:password]
      teacher_info = { mail: @teacher.mail, islogged: true }
      cookies[:teacher_info] = { value: teacher_info.to_json, expires: 1.day.from_now }
      redirect_to teacher_home_url, notice: 'Accesso riuscito!'
    else
      flash.now[:alert] = 'Credenziali non valide.'
    end
  end

  def checklogout
    cookies.delete(:teacher_info)
    redirect_to root_path
  end

  def grade
    @teacher = Teacher.find_by(mail: params[:mail])
  end

  private

  
end