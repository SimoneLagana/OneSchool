class StudentController < ApplicationController
  def login
    if cookies[:student_info].present? && JSON.parse(cookies[:student_info])["islogged"] == true
      redirect_to student_home_url
    end
  end

  def checklogin
    student = Student.find_by(mail: params[:mail])
    if student && student.password == params[:password]
      student_info = { mail: student.mail, islogged: true }
      cookies[:student_info] = { value: student_info.to_json, expires: 30.day.from_now }
      redirect_to student_home_url, notice: 'Accesso riuscito!'
    else
      flash.now[:alert] = 'Credenziali non valide.'
    end
  end

  def checklogout
    cookies.delete(:student_info)
    redirect_to root_path
  end
end