class PasswordMailer < ApplicationMailer
    def email_confirm(user)
        @user=user
        mail(to: @user.mail, subject: 'Conferma cambio password')
    end

end
