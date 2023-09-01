require 'rails_helper'

RSpec.describe Grade, type: :model do

  it 'create a grade' do
    FactoryBot.create(:school)
    FactoryBot.create(:class_room, class_code: "1A", school_code: "1")
    FactoryBot.create(:student, name: "Mario", surname: "Rossi", CF: "60", mail: "mario@rossi", password: "passw", school_code: "1", birthdate: DateTime.new(2001,2,3), student_class_code: "1A", student_school_code: "1")
    FactoryBot.create(:teacher, name: "Luigi", surname: "Colombo", CF: "40", mail: "luigi@colomboi", password: "pas", school_code: "1")
    FactoryBot.create(:new_subject)
    
    grade = Grade.new(
      CFprof: '40',
      CFstudent: '60',
      date: DateTime.new(2023, 9, 19, 0, 0, 0),
      value: 8,
      weekday: 'TUESDAY',
      time: '2',
      subject_name: 'storia',
      class_code: '1A',
      school_code: '1'
    )

    expect(grade).to be_valid
  end

  it 'validate CF prof' do
    FactoryBot.create(:school)
    FactoryBot.create(:class_room, class_code: "1A", school_code: "1")
    FactoryBot.create(:student, name: "Mario", surname: "Rossi", CF: "60", mail: "mario@rossi", password: "passw", school_code: "1", birthdate: DateTime.new(2001,2,3), student_class_code: "1A", student_school_code: "1")
    FactoryBot.create(:teacher, name: "Luigi", surname: "Colombo", CF: "40", mail: "luigi@colomboi", password: "pas", school_code: "1")
    FactoryBot.create(:new_subject)
    
    grade = Grade.new(
        CFprof: nil,
        CFstudent: '60',
        date: DateTime.new(2023, 9, 19, 0, 0, 0),
        value: 8,
        weekday: 'TUESDAY',
        time: '2',
        subject_name: 'storia',
        class_code: '1A',
        school_code: '1'
    )

    expect(grade).not_to be_valid
    expect(grade.errors[:CFprof]).to include("can't be blank")
  end

  it 'double grade unique constraint' do
    FactoryBot.create(:school)
    FactoryBot.create(:class_room, class_code: "1A", school_code: "1")
    FactoryBot.create(:student, name: "Mario", surname: "Rossi", CF: "60", mail: "mario@rossi", password: "passw", school_code: "1", birthdate: DateTime.new(2001,2,3), student_class_code: "1A", student_school_code: "1")
    FactoryBot.create(:teacher, name: "Luigi", surname: "Colombo", CF: "40", mail: "luigi@colomboi", password: "pas", school_code: "1")
    FactoryBot.create(:new_subject)
    
    valid_grade = Grade.create(
        CFprof: '40',
        CFstudent: '60',
        date: DateTime.new(2023, 9, 19, 0, 0, 0),
        value: 8,
        weekday: 'TUESDAY',
        time: '1',
        subject_name: 'storia',
        class_code: '1A',
        school_code: '1'
      )

    
    duplicate_grade = Grade.new(
        CFprof: '40',
        CFstudent: '60',
        date: DateTime.new(2023, 9, 19, 0, 0, 0),
        value: 8,
        weekday: 'TUESDAY',
        time: '2',
        subject_name: 'storia',
        class_code: '1A',
        school_code: '1'
      )

    expect { duplicate_grade.save(validate: false) }.to raise_error(ActiveRecord::StatementInvalid)

    expect(Grade.count).to eq(1)
  end

  it 'record invalid error grade' do
    FactoryBot.create(:school)
    FactoryBot.create(:class_room, class_code: "1A", school_code: "1")
    FactoryBot.create(:student, name: "Mario", surname: "Rossi", CF: "60", mail: "mario@rossi", password: "passw", school_code: "1", birthdate: DateTime.new(2001,2,3), student_class_code: "1A", student_school_code: "1")
    FactoryBot.create(:teacher, name: "Luigi", surname: "Colombo", CF: "40", mail: "luigi@colomboi", password: "pas", school_code: "1")
    FactoryBot.create(:new_subject)
    
    grade = Grade.new(
        CFprof: '44',
        CFstudent: '88',
        date: DateTime.new(2023, 3, 19, 0, 0, 0),
        value: 8,
        weekday: 'Monday',
        time: '1',
        subject_name: 'inglese',
        class_code: '22',
        school_code: '14'
    )

    expect { grade.save! }.to raise_error(ActiveRecord::RecordInvalid)
    expect(Grade.count).to eq(0)
  end

end
