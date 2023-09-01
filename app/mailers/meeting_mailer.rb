class MeetingMailer < ApplicationMailer
    def meeting_request(parent_mail, text, student, teacher)
        @text=text
        @student=student
        @teacher=teacher
        mail(to: parent_mail, subject: 'Meeting request')
    end
end
