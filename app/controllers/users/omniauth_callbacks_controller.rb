# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end
  def google_oauth2
    
    if session[:admin_code].present?
      admin=Admin.find_by(mail: auth.info.email)
      if(admin)
        session[:CF]=admin.uid
        redirect_to=admin_manage_url
      else
        admin=Admin.new(name: auth.info.name, mail: auth.info.email, surname: auth.info.last_name, CF: auth.uid, provider: auth.provider, password: Devise.friendly_token[0, 20])
        if admin
          admin.save
          if admin.save
            session[:CF]=admin.CF
            redirect_to admin_manage_url
          end
        else
          redirect_to root_path
        end
      end
    else
      teacher=Teacher.find_by(mail: auth.info.email)
      if (teacher)
        session[:CF]=teacher.uid
        session[:teacher_code]="google"
        redirect_to teacher_home_url
      else
        cf=JSON.parse(cookies[:teacher])
        school_code=Teacher.where(CF: cf).pluck(:school_code).uniq.first.to_s
        teacher=Teacher.new(name: auth.info.name, mail: auth.info.email, surname: auth.info.last_name, CF: auth.uid, uid: auth.uid, provider: auth.provider, school_code: school_code, password: Devise.friendly_token[0, 20])
        if teacher.save
            session[:teacher_code]="google"
            session.delete(:CF)
            session[:CF]=teacher.CF
            teacher.update(first_login: false)
            redirect_to teacher_home_url 
            return
        end
        redirect_to root_path
      end

    end


    
    #if user.present?
    #  session[:CF]=user.uid
    #  sign_out_all_scopes
    #  flash[:success] = t 'devise.omniauth_callbacks.success', kind: 'Google'
    #  sign_in_and_redirect user, event: :authentication
    #else
    #  flash[:alert] =
    #    t 'devise.omniauth_callbacks.failure', kind: 'Google', reason: "#{auth.info.email} is not authorized."
    #  redirect_to root_path
    #end
  end

  def generic_callback(provider)
    puts(provider)
  end
  
  protected

  def after_omniauth_failure_path_for(_scope)
    root_path
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || root_path
  end

  private

  # def from_google_params
  #   @from_google_params ||= {
  #     uid: auth.uid,
  #     email: auth.info.email,
  #     full_name: auth.info.name,
  #     avatar_url: auth.info.image
  #   }
  # end

  def auth
    @auth ||= request.env['omniauth.auth']
  end

  # More info at:
  # https://github.com/heartcombo/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
