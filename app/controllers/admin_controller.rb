class AdminController < ApplicationController

    def index
        redirect_to "/admin/manage"  
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
    def edit_staff
        @school_staff = SchoolStaff.find(params[:key])
    end
    def update_staff
        @school_staff = SchoolStaff.find(params[:key])
        staff_params = {name: params[:name], surname: params[:surname], CF: params[:CF],mail: params[:mail],
            password: params[:password], school_code: params[:school_code]}
        if @school_staff.update(staff_params)
          redirect_to "/admin/manage"
        else
          render 'edit'
        end
    end
    def delete_staff
        @school_staff = SchoolStaff.find(params[:CF])
        if @school_staff.destroy
            redirect_to "/admin/manage"
        else
            render 'delete'
        end
    end      
    def edit_school
        @school = School.find(params[:key])
    end
    def update_school
        @school = School.find(params[:key])
        @new_school = params[:code]        
        school_params = {address: params[:address], name: params[:name], code: @new_school,school_type: params[:school_type]}
        if @school.update(school_params)
          redirect_to "/admin/manage"
        else
          render 'edit'
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
        else
            render 'delete'
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