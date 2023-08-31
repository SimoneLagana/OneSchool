class AdminController < ApplicationController

    before_action :check_session_login, except: [:login, :checklogin, :create, :signup]
    def index
        redirect_to "/admin/manage"  
    end
    def signup
        session[:admin_code]="google"       
    end



    def login
        session[:admin_code]="google"
    end

    def checklogin
        @admin = Admin.find_by(mail: params[:mail])
        if @admin && @admin.password == params[:password]
          session[:CF]= @admin.CF
          redirect_to admin_manage_url
          
        else
          redirect_to admin_login_url
          flash[:alert] = 'Credenziali non valide.'
        end
      end

    def checklogout
        session.delete(:CF)
        session.delete(:admin_code)
        redirect_to root_path
        
    end

    def delete_account
        admin=Admin.find_by(CF: session[:CF])
        session.delete(:admin_code)
        session.delete(:CF)
        cookies.delete(:admin_params)
        if admin.delete
            puts("account eliminato con successo")
            redirect_to root_path
        else
            redirect_to admin_profile_url
            flash[:alert]= "errore nell'eliminazione"
        end
    end

    def check_session_login
        unless session[:CF].present?
            redirect_to admin_login_url, alert: "Effettua l'accesso per continuare."
        end
    end

    def manage
        
    end

    def profile
        @admin = Admin.find_by(CF: session[:CF])
    end

    def upgradepassword
        @admin=Admin.find_by(CF: params[:CF])
        puts("ciao")
        @admin.update(password: $passk)
        puts("fatta")
        redirect_to admin_manage_url
    end
    
    def changepassword
        @admin=Admin.find_by(CF: session[:CF])
        pass=params[:old_password]
        $passk=params[:password]
        if(@admin) && @admin.password == pass
          PasswordMailer.admin_email_confirm(@admin).deliver_now
        else
          redirect_to admin_login_url
          flash[:alert]= "password inserita errata"
        end
        pass=""
    end

    #Registra un nuovo Admin dal form.
    def create
        admin_params = { name: params[:name], surname: params[:surname],CF: params[:CF], mail: params[:email],password: params[:password] }
        cookies[:admin_params]={value: admin_params.to_json, expires: 30.day.from_now}
        session[:CF]= params[:CF]
        @admin = Admin.new(admin_params)
        begin
            if @admin.save
              redirect_to admin_manage_url
            else
              flash[:alert] = "error while creating admin"
              redirect_to admin_signup_url
            end
          rescue ActiveRecord::RecordNotUnique => e
            flash[:alert] = "This admin is already inserted."
            redirect_to admin_login_url
          end
    end

    def create_school
        if params[:address] ==""
            redirect_to admin_manage_path 
            flash[:alertt] = "Insert an address"
            return
        end

        if params[:name] ==""
            redirect_to admin_manage_path 
            flash[:alertt] = "Insert a name"
            return
        end

        if params[:code] ==""
            redirect_to admin_manage_path 
            flash[:alertt] = "Insert a code"
            return            
        end


        if School.where(code: params[:code]).exists?
            redirect_to admin_manage_path 
            flash[:alertt] = "School already registred"
            return
        end

        if params[:school_type]==""
            redirect_to admin_manage_path 
            flash[:alertt] = "Insert a school type"
            return            
        end
                
        school_params = {address: params[:address], name: params[:name], code: params[:code],school_type: params[:school_type]}

        @school = School.new(school_params)
        if @school.save
            @classroom = ClassRoom.create(school_code: params[:code],class_code: "STUDENTS_WITHOUT_CLASS")
            redirect_to "/admin/manage"
            flash[:noticee] = "School correctly registred"
        end
    end

    def create_staff
        if params[:name] == ""
            redirect_to "/admin/manage"
            flash[:alert] = "Missing the name"
            return
        end
        if params[:surname] == ""
            redirect_to "/admin/manage"
            flash[:alert] = "Missing the surname"
            return
        end   
        if params[:CF] == ""
            redirect_to "/admin/manage"
            flash[:alert] = "Missing the CF"
            return
        end
        if User.where(CF: params[:CF]).exists?
            redirect_to "/admin/manage"
            flash[:alert] = "User already registered"
            return
        end
        if params[:mail] == ""
            redirect_to "/admin/manage"
            flash[:alert] = "Missing the mail"
            return
        end
        if User.where(mail: params[:mail]).exists?
            redirect_to "/admin/manage"
            flash[:alert] = "User already registered"
            return
        end
        if params[:password] == ""
            redirect_to "/admin/manage"
            flash[:alert] = "Missing the password"
            return
        end
        if params[:school_code] == ""
            redirect_to "/admin/manage"
            flash[:alert] = "Missing the School code"
            return
        end
        if !School.where(code: params[:school_code]).exists?
            redirect_to "/admin/manage"
            flash[:alert] = "School doesn't exist"
            return
        end          
        staff_params = {name: params[:name], surname: params[:surname], CF: params[:CF],mail: params[:mail],
            password: params[:password], school_code: params[:school_code]}

        @school_staff = SchoolStaff.new(staff_params)
        if @school_staff.save
            flash[:notice] = "School staff correctly registred"
            redirect_to "/admin/manage"
        else
            flash[:alert] = "Error on create"
            redirect_to "/admin/manage"
        end
    
    end

    def edit_staff
        @school_staff = SchoolStaff.find(params[:key])
    end

    def update_staff
        @school_staff = SchoolStaff.find(params[:key])
        if User.where(mail: params[:mail]).where.not(CF: params[:key]).exists?
            redirect_to "/admin/manage"
            flash[:alert] = "Email already registered,please insert another one"
            return
        end
        if !School.where(code: params[:school_code]).exists?
            redirect_to "/admin/manage"
            flash[:alert] = "School doesn't exist"
            return
        end            
        staff_params = {name: params[:name], surname: params[:surname], mail: params[:mail],
            password: params[:password], school_code: params[:school_code]}
        if @school_staff.update(staff_params)
          redirect_to "/admin/manage"
          flash[:notice] = "Updated informations"
        else
            redirect_to "/admin/manage"
            flash[:alert] = "Error on update, check and fill correctly all the fields"
        end
    end

    def delete_staff
        @school_staff = SchoolStaff.find(params[:CF])
        if @school_staff.destroy
            redirect_to "/admin/manage"
            flash[:notice] = "Deleted account"

        else
            redirect_to "/admin/manage"
            flash[:alert] = "Error on delete"
        end
    end   

    def edit_school
        @school = School.find(params[:key])
    end

    def update_school
        if School.where(code: params[:code]).exists?
            redirect_to admin_manage_path 
            flash[:alertt] = "School already registred"
            return
        end
        @school = School.find(params[:key])
        @new_school = params[:code]        
        school_params = {address: params[:address], name: params[:name], code: params[:key],school_type: params[:school_type]}
        if @school.update(school_params)
          redirect_to "/admin/manage"
          flash[:noticee] = "School correctly updated"
        else
            redirect_to "/admin/manage"
            flash[:alertt] = "Error on update"
        end
    end


    def delete_school
        @school = School.find(params[:code])
        @commitment = Commitment.where(school_code: @school.code)
        @commitment.delete_all
        @homework = Homework.where(school_code: @school.code)
        @homework.delete_all
        @grade = Grade.where(school_code: @school.code)
        @grade.delete_all
        @absence = Absence.where(school_code: @school.code)
        @absence.delete_all
        @note = Note.where(school_code: @school.code)
        @note.delete_all
        @subject = Subject.where(school_code: @school.code)
        @subject.delete_all
        @communication = Communication.where(school_code: @school.code)
        @communication.delete_all
        @familystudent = FamilyStudent.where(school_code: @school.code)
        @familystudent.delete_all
        if @school.destroy
            redirect_to "/admin/manage"
            flash[:noticee] = "School correctly deleted"

        else
            redirect_to "/admin/manage"
            flash[:noticee] = "Error on delete"
        end
    end       
    def school_params
        params.require(:school).permit(:address, :name, :code, :school_type)
    end
        
    def search_school
        @ret = School.where('lower(name) = ?',params[:search].downcase )
        if @ret.exists?
            # flash[:results] = @ret
            render 'manage'
        else
            @ret = "NOT_FOUND"
            render 'manage'
        end

    end
    def search_staff
        @ret_staff = SchoolStaff.where('lower(school_code) = ?',  params[:search].downcase)
        if @ret_staff.exists?
            # flash[:results] = @ret
            render 'manage'
        else
            @ret_staff = "NOT_FOUND"
            render 'manage'
        end
    end


end