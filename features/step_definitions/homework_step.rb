Given("there is a teacher and a student with mail and password") do
    FactoryBot.create(:school)
    FactoryBot.create(:class_room, class_code: "1A", school_code: "1")
    FactoryBot.create(:student, name: "Mario", surname: "Rossi", CF: "60", mail: "mario@rossi", password: "passw", school_code: "1", birthdate: DateTime.new(2001,2,3), student_class_code: "1A", student_school_code: "1")
    FactoryBot.create(:student, name: "Simone", surname: "Verdi", CF: "61", mail: "simone@verdi", password: "simonepas", school_code: "1", birthdate: DateTime.new(2008,2,3), student_class_code: "1A", student_school_code: "1")
    FactoryBot.create(:teacher, name: "Luigi", surname: "Colombo", CF: "40", mail: "luigi@colomboi", password: "pas", school_code: "1")
    FactoryBot.create(:subject, weekday: "martedì", time: "2", school_code: "1", CFprof: "40", class_code: "1A", name: "storia")
    FactoryBot.create(:home1, delivered: false, text: "saggio breve", date: DateTime.new(2023, 9, 15, 0,0,0), name: "saggio", weekday: "martedì", time: "2", school_code: "1", class_code: "1A", CFprof: "40", subject_name: "storia")


end

Given("I have an account and I am logged in as a teacher") do
    visit root_path
    click_link "Teacher"
    expect(current_path).to eq(teacher_login_path)
    @teacher = Teacher.find_by(CF: "40")
    fill_in 'email-field', with: @teacher.mail
    fill_in 'password-field', with: @teacher.password
    click_button 'login-button'
end

And ("I am on my teacher home page") do
    expect(current_path).to eq(teacher_home_path)
end

Then ("I should see the select with the text {string}") do |text|
    expect(page).to have_content(text)
end

When ("I click on the button {string}") do |title|
    click_button title
end

When("I select my classroom") do 
    select('1A', from: 'select-class') 
    click_button('select_btn')
  end
  

Then ("I should be again in the teacher homepage") do
    expect(current_path).to eq(teacher_home_path)
end

And ("I should see this error message {string}") do |class_error|
    expect(page).to have_content(class_error)
end

Then ("I should be on the class page {string}") do |path|
    expect(current_path).to eq(path)
end 

And ("I should see the class name on the page") do 
    expect(page).to have_content('Classroom: 1A')
end

When ("I click on the homework panel {string}") do |panel|
    click_link panel
end

Then ("I should be on the homework page {string}") do |path|
    expect(current_path).to eq(path)
end

When ("I click the homework submit button") do
    click_button "Save homework"
end

Then ("I should see the error message containing {string}") do |error|
    expect(page).to have_content(error)
end

When("I fill in the creation with subject, name {string}, and description") do |name|
    select "storia", from: 'homework-field-subject'
    fill_in 'homework-field-name', with: name
    fill_in 'text-area', with: "due-tomorrow"
  end

And ("I fill in the form with yesterday's date") do
    date = DateTime.new(2023, 8, 29, 14, 30)
    date_field = find('#date')
    date_field.set(date.strftime('%Y-%m-%dT%H:%M'))
end

And ("I fill in the form with tomorrow's date") do
    date = DateTime.new(2023, 9, 20, 14, 30)
    date_field = find('#date')
    date_field.set(date.strftime('%Y-%m-%dT%H:%M'))
end

Then ("I should see the date's error message containing {string}")  do |error_date|
    expect(page).to have_content(error_date)
end

Then ("I should see on the screen {string}") do |homework_title|
    expect(page).to have_content(homework_title)
end

Given("I have an account and I am logged in as a student") do
    visit root_path
    click_link "Student"
    expect(current_path).to eq(student_login_path)
    @student = Student.find_by(CF: "60")
    fill_in 'email-field', with: @student.mail
    fill_in 'password-field', with: @student.password
    click_button 'login-button'
end

And ("I am in my classroom home page") do
    expect(current_path).to eq(student_home_path)
    expect(page).to have_content("Classroom: 1A")
end

When ("I click on the assignment panel {string}") do |panel_name|
    click_link panel_name
end

Then ("I should see the due homework and the submitted homeworks") do
    expect(page).to have_content("Due homeworks")
    expect(page).to have_content("Submitted homeworks")
end

When ("I fill in the other members for the homework {string}") do |homework_member|
    fill_in 'other', with: homework_member
end

And ("I forget to fill the mail's text") do
    click_button 'Submit'
end

Then ("I should see the message on the screen {string}") do |error|
    expect(page).to have_content(error)
end

And ("I fill the mail's text with {string}") do |text|
    fill_in 'mail-text', with: text
    
end

And ("I submit the homework form") do
    click_button 'Submit'
end

Then ("I should see the file error message on the screen {string}") do |error|
    expect(page).to have_content(error)
end

And ("I upload a file") do
    attach_file('file', "#{Rails.root}/storage/uploads/prova.txt")
end

Then ("I should see within the submitted homeworks the title of my homework") do
    within '.list-homework-panel' do
        expect(page).to have_text("saggio")
      end
end

When ("I click on the agenda panel {string}") do |panel_title|
    click_link panel_title
end

Then ("I should be in the class agenda page") do
    expect(current_path).to eq(student_agenda_path)
end

And ("I should be able to se my due homework") do
    expect(page).to have_text("saggio")
end
