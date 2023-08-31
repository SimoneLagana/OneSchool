class PasswordMailer < ApplicationMailer
    def email_confirm(user)
        @user=user
        mail(to: @user.mail, subject: 'Confirm password change')
    end

    def admin_email_confirm(admin)
        @admin=admin
        mail(to: @admin.mail, subject: 'Confirm password change')
    end
end
