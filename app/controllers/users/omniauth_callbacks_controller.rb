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
        session[:CF]=admin.CF
        session[:admin_code]="google"
        redirect_to admin_manage_url
        return
      else
        if cookies[:admin_params].present?
          name=JSON.parse(cookies[:admin_params])["name"]
          surname=JSON.parse(cookies[:admin_params])["surname"]
          admin=Admin.new(name: name, mail: auth.info.email, surname: surname, CF: auth.uid, provider: auth.provider, password: Devise.friendly_token[0, 20])
        else
          admin=Admin.new(name: auth.info.name, mail: auth.info.email, surname: auth.info.name, CF: auth.uid, provider: auth.provider, password: Devise.friendly_token[0, 20])
        end
        if admin.save
          session[:CF]=admin.CF
          session[:admin_code]="google"
          redirect_to admin_manage_url
          return
        end
        redirect_to root_path
        return
      end
    else
      cf=JSON.parse(cookies[:teacher])
      teacher=Teacher.find_by(CF: cf)
      
      @user = Teacher.from_omniauth(request.env["omniauth.auth"],cf, teacher.name, teacher.surname)
      
      if @user.persisted?
        
        session[:CF]=@user.CF
        @user.update(first_login: false)
        session[:teacher_code]="google"
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
        sign_in @user, :event => :authentication
        redirect_to teacher_home_url
      else
        flash[:alert]="errore nell'autenticazione!"
        redirect_to teacher_login_url
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
