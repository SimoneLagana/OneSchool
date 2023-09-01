class SubmitMailer < ApplicationMailer
    def submit_homework(teacher, student, text, homework)
        @teacher=teacher
        @student_name=student
        @text=text
        @homework=homework
        if @homework.file.attached?
            file_path = Rails.application.routes.url_helpers.rails_blob_path(@homework.file, only_path: true)
            #attachments[@homework.file.filename.to_s] = File.read(file_path)
          end
        mail(to: @teacher.mail, subject: "Homework Delivery")
    end
end
