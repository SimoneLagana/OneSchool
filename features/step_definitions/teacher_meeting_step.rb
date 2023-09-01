Given("there is a new user with mail and password") do
    FactoryBot.create(:school)
    FactoryBot.create(:class_room, class_code: "1A", school_code: "1")
    FactoryBot.create(:student, name: "Mario", surname: "Rossi", CF: "60", mail: "mario@rossi", password: "passw", school_code: "1", birthdate: DateTime.new(2001,2,3), student_class_code: "1A", student_school_code: "1")
    FactoryBot.create(:student, name: "Simone", surname: "Verdi", CF: "61", mail: "simone@verdi", password: "simonepas", school_code: "1", birthdate: DateTime.new(2008,2,3), student_class_code: "1A", student_school_code: "1")
    FactoryBot.create(:family, name: "Maria", surname: "Rossi", CF: "7", mail: "maria@Rossi", password: "samir", school_code: "1")
    FactoryBot.create(:family_student, id: 1, CFfamily: "7", CFstudent: "60", school_code: "1")
    FactoryBot.create(:teacher, name: "Luigi", surname: "Colombo", CF: "40", mail: "luigi@colomboi", password: "pas", school_code: "1")
    FactoryBot.create(:subject, weekday: "martedì", time: "2", school_code: "1", CFprof: "40", class_code: "1A", name: "storia")
    FactoryBot.create(:meeting, id: 9, title: "Meeting con Enzo Esposito", date: DateTime.new(2023, 8, 30, 18, 0, 0), CFprof: "40", CFfamily: "7")
    FactoryBot.create(:absence)
    FactoryBot.create(:absence_j)
    FactoryBot.create(:absence_sv)
    FactoryBot.create(:absence_sv_j)
  end


  Given("I login as a teacher user") do
    visit root_path
    click_link "Teacher"
    expect(current_path).to eq(teacher_login_path)
    @teacher = Teacher.find_by(CF: "40")
    fill_in 'email-field', with: @teacher.mail
    fill_in 'password-field', with: @teacher.password
    click_button 'login-button'
  end
  
  And("I am in the teacher user home page") do
    expect(current_path).to eq(teacher_home_path)
  end
  
  When ("I click on the meeting panel {string}") do |panel|
    click_link panel
  end
  
  Then ("I should be in the teacher meeting page") do 
    expect(current_path).to eq(teacher_meeting_path)
  end
  
  And ("when I should see the meeting link") do
    page.has_text?('go to meeting')
  end
  
  Then("I should see a panel with the text {string}") do |text|
    expect(page).to have_content(text)
  end
  
  When("I select the classroom {string}") do |classroom|
    select classroom, from: 'select-class'
    click_button 'select_btn'
  end
  
  Then("I should be on the page {string}") do |url|
    expect(current_path).to eq(url)
  end
  
  And("I should see the text {string} on the page") do |text|
    expect(page).to have_content(text)
  end
  
  When("I click on the request panel {string}") do |panel|
    click_link panel
  end
  
  When("I click the submit button") do
    click_button 'Send meeting request'
  end
  
  Then("I should see an error message containing {string}") do |error_message|
    expect(page).to have_content(error_message)
  end
  
  When ("I select the first student and write the text {string}") do |text|
    fill_in 'request-text', with: text
  end
  
  Then ("I should see a message containing {string}") do |message|
    expect(page).to have_content(message)
  end
  