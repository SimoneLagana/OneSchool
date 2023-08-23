class AdminController < ApplicationController

    def index
    end
    def signup       
    end
    def manage        
    end

    #Registra un nuovo Admin dal form.
    def create
        admin_params = { name: params[:name], surname: params[:surname],CF: params[:CF], mail: params[:email],password: params[:password] }
        
        @admin = Admin.new(admin_params)
        if @admin.save
            redirect_to "/admin/manage"
        else
            flash[:alert] = "Si è verificato un errore durante la creazione del post."
        end
    end

    def create_school
        school_params = {address: params[:address], name: params[:name], code: params[:code],school_type: params[:school_type]}

        @school = School.new(school_params)
        if @school.save
            redirect_to "/admin/manage"
        end
    end

    def create_staff
        staff_params = {name: params[:name], surname: params[:surname], CF: params[:CF],mail: params[:mail],
            password: params[:password], school_code: params[:school_code]}

        @school_staff = SchoolStaff.new(staff_params)
        if @school_staff.save
            redirect_to "/admin/manage"
        end
    end    
    def edit_school
        @school = School.find(params[:key])
    end
    def update_school
        @school = School.find(params[:key])
        school_params = {address: params[:address], name: params[:name], code: params[:code],school_type: params[:school_type]}
        if @school.update(school_params)
          redirect_to "/admin/manage"
        else
          render 'edit'
        end
    end
    def delete_school
        @school = School.find(params[:code])
        if @school.destroy
            redirect_to "/admin/manage"
          else
            render 'delete'
        end
    end    
    def school_params
        params.require(:school).permit(:address, :name, :code, :school_type)
    end    


end
