class FamilyController < ApplicationController
  def login
    if cookies[:family_info].present? && JSON.parse(cookies[:family_info])["islogged"] == true
      redirect_to family_home_url
    end
  end

  def checklogin
    family = Family.find_by(mail: params[:mail])
    if family && family.password == params[:password]
      family_info = { mail: family.mail, islogged: true }
      cookies[:family_info] = { value: family_info.to_json, expires: 30.day.from_now }
      redirect_to family_home_url, notice: 'Accesso riuscito!'
    else
      flash.now[:alert] = 'Credenziali non valide.'
    end
  end

  def checklogout
    cookies.delete(:family_info)
    redirect_to root_path
  end
end