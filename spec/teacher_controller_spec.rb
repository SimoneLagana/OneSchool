require 'rails_helper'

RSpec.describe TeacherController, type: :controller do
  describe 'POST #insertabsence' do
    it 'tries to create an absence when the field subject is not in the params' do
      session[:CF]='40'
      FactoryBot.create(:school)
      FactoryBot.create(:class_room, class_code: "1A", school_code: "1")
      FactoryBot.create(:student, name: "Mario", surname: "Rossi", CF: "60", mail: "mario@rossi", password: "passw", school_code: "1", birthdate: DateTime.new(2001,2,3), student_class_code: "1A", student_school_code: "1")
      FactoryBot.create(:teacher, name: "Luigi", surname: "Colombo", CF: "40", mail: "luigi@colomboi", password: "pas", school_code: "1")
      FactoryBot.create(:subject, weekday: "TUESDAY", time: "2", school_code: "1", CFprof: "40", class_code: "1A", name: "storia")
      FactoryBot.create(:absence)
      
      post :insertabsence, params: {
        date: DateTime.now,
        CFstudent: '60',
        CFprof: '40',
        class_code: '1A',
        school_code: '1',
        justified: false
      }
      expect(response).to redirect_to(teacher_absence_url(classroom: '1A'))
      expect(flash[:alert]).to be_present
      expect(flash[:alert]).to eq("select a subject")
      
     
    end
    it 'tries to create and absence when the field date does not match the weekday' do
      session[:CF]='40'
      FactoryBot.create(:school)
      FactoryBot.create(:class_room, class_code: "1A", school_code: "1")
      FactoryBot.create(:student, name: "Mario", surname: "Rossi", CF: "60", mail: "mario@rossi", password: "passw", school_code: "1", birthdate: DateTime.new(2001,2,3), student_class_code: "1A", student_school_code: "1")
      FactoryBot.create(:teacher, name: "Luigi", surname: "Colombo", CF: "40", mail: "luigi@colomboi", password: "pas", school_code: "1")
      FactoryBot.create(:subject, weekday: "TUESDAY", time: "2", school_code: "1", CFprof: "40", class_code: "1A", name: "storia")
      FactoryBot.create(:absence)
      
      post :insertabsence, params: {
        subject_name: 'storia',
        weekday: 'TUESDAY',
        time: '2',
        date: DateTime.now,
        CFstudent: '60',
        CFprof: '40',
        class_code: '1A',
        school_code: '1',
        justified: false
      }
      expect(response).to redirect_to(teacher_absence_url(classroom: '1A'))
      expect(flash[:alert]).to be_present
      expect(flash[:alert]).to eq("error weekday and date don't match")
      
    end
  end

  describe 'GET #absence' do
    it 'tries to select a subject from the first select and the second select should fill up' do
      session[:CF]='40'
      FactoryBot.create(:school)
      FactoryBot.create(:class_room, class_code: "1A", school_code: "1")
      FactoryBot.create(:student, name: "Mario", surname: "Rossi", CF: "60", mail: "mario@rossi", password: "passw", school_code: "1", birthdate: DateTime.new(2001,2,3), student_class_code: "1A", student_school_code: "1")
      FactoryBot.create(:teacher, name: "Luigi", surname: "Colombo", CF: "40", mail: "luigi@colomboi", password: "pas", school_code: "1")
      FactoryBot.create(:subject, weekday: "TUESDAY", time: "2", school_code: "1", CFprof: "40", class_code: "1A", name: "storia")
      
      get :absence, params: {
        classroom: '1A',
        subject: 'storia'
      }

      expect(response).to have_http_status(:success)
      expect(assigns(:subjects)).to eq([["Subject", nil], "storia"])
      expect(assigns(:weekdays)).to eq([["Select weekday", nil], "TUESDAY"])
    end
    it 'tries to select a weekday from the second select and the third select should fill up' do
      session[:CF]='40'
      FactoryBot.create(:school)
      FactoryBot.create(:class_room, class_code: "1A", school_code: "1")
      FactoryBot.create(:student, name: "Mario", surname: "Rossi", CF: "60", mail: "mario@rossi", password: "passw", school_code: "1", birthdate: DateTime.new(2001,2,3), student_class_code: "1A", student_school_code: "1")
      FactoryBot.create(:teacher, name: "Luigi", surname: "Colombo", CF: "40", mail: "luigi@colomboi", password: "pas", school_code: "1")
      FactoryBot.create(:subject, weekday: "TUESDAY", time: "2", school_code: "1", CFprof: "40", class_code: "1A", name: "storia")
      
      get :absence, params: {
        classroom: '1A',
        subject: 'storia',
        weekday: 'TUESDAY'
      }

      expect(response).to have_http_status(:success)
      expect(assigns(:subjects)).to eq([["Subject", nil], "storia"])
      expect(assigns(:weekdays)).to eq([["Select weekday", nil], "TUESDAY"])
      
      expect(assigns(:times)).to eq([["Select school hour", nil], "2"])
      
    end
  end

  describe 'POST #insertgrade'do
    let(:wrong_params) do
      {
        subject_name: 'storia',
        weekday: 'TUESDAY',
        time: '2',
        date: DateTime.new(2023, 9, 6, 0, 0, 0),
        CFstudent: ['60'],
        CFprof: '40',
        class_code: '1A',
        school_code: '1',
        value: 8
      }
    end

    let(:double_params) do
      {
        subject_name: 'storia',
        weekday: 'TUESDAY',
        time: '1',
        date: DateTime.new(2023, 9, 12, 0, 0, 0),
        CFstudent: ['60'],
        CFprof: '40',
        class_code: '1A',
        school_code: '1',
        value: 8
      }
    end

    let(:right_params) do
      {
        subject_name: 'storia',
        weekday: 'TUESDAY',
        time: '1',
        date: DateTime.new(2023, 9, 19, 0, 0, 0),
        CFstudent: ['60'],
        CFprof: '40',
        class_code: '1A',
        school_code: '1',
        value: 6
      }
    end

    it 'creates a new grade wrong date params' do
      session[:CF]='40'
      FactoryBot.create(:school)
      FactoryBot.create(:class_room, class_code: "1A", school_code: "1")
      FactoryBot.create(:student, name: "Mario", surname: "Rossi", CF: "60", mail: "mario@rossi", password: "passw", school_code: "1", birthdate: DateTime.new(2001,2,3), student_class_code: "1A", student_school_code: "1")
      FactoryBot.create(:teacher, name: "Luigi", surname: "Colombo", CF: "40", mail: "luigi@colomboi", password: "pas", school_code: "1")
      FactoryBot.create(:subject, weekday: "TUESDAY", time: "2", school_code: "1", CFprof: "40", class_code: "1A", name: "storia")

      post :insertgrade, params: wrong_params

      expect(response).to redirect_to(teacher_grade_url(classroom: '1A'))
      expect(flash[:alert]).to eq("error weekday and date don't match")
    end

    it 'creates a new grade with valid parameters' do
      session[:CF]='40'
      FactoryBot.create(:school)
      FactoryBot.create(:class_room, class_code: "1A", school_code: "1")
      FactoryBot.create(:student, name: "Mario", surname: "Rossi", CF: "60", mail: "mario@rossi", password: "passw", school_code: "1", birthdate: DateTime.new(2001,2,3), student_class_code: "1A", student_school_code: "1")
      FactoryBot.create(:teacher, name: "Luigi", surname: "Colombo", CF: "40", mail: "luigi@colomboi", password: "pas", school_code: "1")
      FactoryBot.create(:new_subject)

      post :insertgrade, params: right_params

      expect(response).to redirect_to(teacher_grade_url(classroom: '1A'))
      expect(flash[:alert]).to be nil
      expect(Grade.count).to eq(1)
      grade = Grade.first
      expect(grade.subject_name).to eq('storia')
      expect(grade.weekday).to eq('TUESDAY')
      expect(grade.time).to eq('1')
    end

    it 'Tries to insert a new grade the same day as another one' do
      session[:CF]='40'
      FactoryBot.create(:school)
      FactoryBot.create(:class_room, class_code: "1A", school_code: "1")
      FactoryBot.create(:student, name: "Mario", surname: "Rossi", CF: "60", mail: "mario@rossi", password: "passw", school_code: "1", birthdate: DateTime.new(2001,2,3), student_class_code: "1A", student_school_code: "1")
      FactoryBot.create(:teacher, name: "Luigi", surname: "Colombo", CF: "40", mail: "luigi@colomboi", password: "pas", school_code: "1")
      FactoryBot.create(:new_subject)
      FactoryBot.create(:grade_1)
      post :insertgrade, params: double_params
      expect(response).to redirect_to(teacher_grade_url(classroom: '1A'))
      expect(flash[:alert]).to eq("This grade is already inserted.")
    end


  end

  describe 'POST #insertmeeting' do
    it 'sends a successfull meeting request' do
      FactoryBot.create(:school)
      FactoryBot.create(:class_room, class_code: "1A", school_code: "1")
      FactoryBot.create(:student, name: "Mario", surname: "Rossi", CF: "60", mail: "mario@rossi", password: "passw", school_code: "1", birthdate: DateTime.new(2001,2,3), student_class_code: "1A", student_school_code: "1")
      FactoryBot.create(:teacher, name: "Luigi", surname: "Colombo", CF: "40", mail: "luigi@colomboi", password: "pas", school_code: "1")
      FactoryBot.create(:family, name: "Maria", surname: "Rossi", CF: "7", mail: "maria@Rossi", password: "samir", school_code: "1")
      FactoryBot.create(:family_student, id: 1, CFfamily: "7", CFstudent: "60", school_code: "1")
      session[:CF]='40'
      post :insertmeeting, params: {
        CFstudent: '60',
        CFprof: '40',
        text: 'request meeting for his/her student',
        class_code: '1A',
        school_code: '1'
      }
      expect(assigns(:parent_mail)).to eq(["maria@Rossi"])
      expect(ActionMailer::Base.deliveries).not_to be_empty
  
      
      last_email = ActionMailer::Base.deliveries.last
      expect(last_email.to).to eq(['maria@Rossi']) 
      expect(last_email.subject).to eq('Meeting request')   
      
      expect(response).to redirect_to(teacher_requestmeeting_url(classroom: '1A', confirm: 'conferma'))
    end

    it 'fails to send a meeting request' do
      FactoryBot.create(:school)
      FactoryBot.create(:class_room, class_code: "1A", school_code: "1")
      FactoryBot.create(:student, name: "Mario", surname: "Rossi", CF: "60", mail: "mario@rossi", password: "passw", school_code: "1", birthdate: DateTime.new(2001,2,3), student_class_code: "1A", student_school_code: "1")
      FactoryBot.create(:teacher, name: "Luigi", surname: "Colombo", CF: "40", mail: "luigi@colomboi", password: "pas", school_code: "1")
      FactoryBot.create(:family, name: "Maria", surname: "Rossi", CF: "7", mail: "maria@Rossi", password: "samir", school_code: "1")
      FactoryBot.create(:family_student, id: 1, CFfamily: "7", CFstudent: "60", school_code: "1")
      session[:CF]='40'
      post :insertmeeting, params: {
        CFstudent: '60',
        CFprof: '40',
        class_code: '1A',
        school_code: '1'
      }

      expect(response).to redirect_to(teacher_requestmeeting_url(classroom: '1A'))
      expect(flash[:alert]).to eq("write text")
      
    end
    
  end
end
