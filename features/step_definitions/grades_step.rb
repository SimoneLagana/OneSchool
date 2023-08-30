Given("there is a teacher with email and password") do
    FactoryBot.create(:school)
    FactoryBot.create(:class_room, class_code: "1A", school_code: "1")
    FactoryBot.create(:student, name: "Mario", surname: "Rossi", CF: "60", mail: "mario@rossi", password: "passw", school_code: "1", birthdate: DateTime.new(2001,2,3), student_class_code: "1A", student_school_code: "1")
    FactoryBot.create(:family, name: "Maria", surname: "Rossi", CF: "7", mail: "maria@Rossi", password: "samir", school_code: "1")
    FactoryBot.create(:family_student, id: 1, CFfamily: "7", CFstudent: "60", school_code: "1")
    FactoryBot.create(:teacher, name: "Luigi", surname: "Colombo", CF: "40", mail: "luigi@colomboi", password: "pas", school_code: "1")
    FactoryBot.create(:subject, weekday: "martedì", time: "2", school_code: "1", CFprof: "40", class_code: "1A", name: "storia")
    FactoryBot.create(:meeting, id: 9, title: "Meeting con Enzo Esposito", date: DateTime.new(2023, 8, 30, 18, 0, 0), CFprof: "40", CFfamily: "7")
    visit root_path
  end


  When("I click on {string} panel") do |panel_name| 
    click_link panel_name
  end

  Then("I should be on the login page") do
    expect(current_path).to eq(teacher_login_path)
  end

  When("I fill email field with {string}") do |value|
    fill_in 'email-field', with: value
  end
  
  And("I fill password field with {string}") do |value|
    fill_in 'password-field', with: value
  end
  
  And("I click the button to login") do
    click_button 'login-button'
  end
  
  Given("I am on the teacher home") do
    expect(current_path).to eq(teacher_home_path)
  end

  When("I select the class {string}") do |class_name| 
    select class_name, from: 'classroom'
  end

  And("I click the button {string}") do |btn|
    click_button btn
  end

  Then("I should be on the right classroom's page") do
    expect(current_path).to eq(teacher_classroom_path)
  end

  When("I click on the {string} panel ") do |panel_name| 
    click_link panel_name
  end

  Then("I should be in the teacher's grade page") do
    expect(current_path).to eq(teacher_grade_path)
    
  end

  When("I select the subject {string}") do |sub_name| 
    select sub_name, from: 'subject'
    expect(current_path).to eq(teacher_grade_path)
    click_button "submitt"
    
  end
        
  And("I select the desired weekday {string}") do |weekday_name| 
    select weekday_name, from: 'weekday'
    click_button "submitt"
  end

  And("I select the right time: {string}") do |right_time| 
    select right_time, from: 'time'
    click_button "submitt"
  end

  And("I select the student {string}") do |student| 
    select student, from: 'CFstudent[]'
  end

  And("I insert the date {string} {string} {string}") do |day, month, year| 
    data = "value " + year + "-" + month + "-" + day
    date_input = find("#date")
    date_input.set(data)
  end

  And("I set the grade to {int}") do |grade| 
    date_input = find("#value")
    date_input.set(grade)
  end

  And("I click on the {string}") do |btn| 
    click_button btn
  end

  Then("I should have a grade for Mario for the subject {string} on {int} {int} {int}") do |subj, day, month, year|
    d = DateTime.new(year, month, day, 0, 0, 0)
    grade = Grade.find_by(date: d, CFprof: "40", subject_name: subj, CFstudent: "60")
    code = grade.id
    expect(page).to have_selector("##{code}")
  end
  
  

  