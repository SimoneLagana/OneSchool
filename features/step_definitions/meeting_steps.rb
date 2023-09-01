# Assuming you have a step_definitions directory where you keep your step definition files

# step_definitions/family_dashboard_steps.rb
Given("there is a user with email and password") do
  FactoryBot.create(:school)
  FactoryBot.create(:class_room, class_code: "1A", school_code: "1")
  FactoryBot.create(:class_room, class_code: "1B", school_code: "1")
  FactoryBot.create(:student, name: "Mario", surname: "Rossi", CF: "60", mail: "mario@rossi", password: "passw", school_code: "1", birthdate: DateTime.new(2001,2,3), student_class_code: "1A", student_school_code: "1")
  FactoryBot.create(:student, name: "Simone", surname: "Verdi", CF: "61", mail: "simone@verdi", password: "simonepas", school_code: "1", birthdate: DateTime.new(2008,2,3), student_class_code: "1A", student_school_code: "1")
  FactoryBot.create(:family, name: "Maria", surname: "Rossi", CF: "7", mail: "maria@Rossi", password: "samir", school_code: "1")
  FactoryBot.create(:family_student, id: 1, CFfamily: "7", CFstudent: "60", school_code: "1")
  FactoryBot.create(:family_student, id: 2, CFfamily: "7", CFstudent: "61", school_code: "1")
  FactoryBot.create(:teacher, name: "Luigi", surname: "Colombo", CF: "40", mail: "luigi@colomboi", password: "pas", school_code: "1")
  FactoryBot.create(:teacher, name: "Fabio", surname: "Ralli", CF: "999", mail: "fabio@ralli", password: "pas", school_code: "1")
  FactoryBot.create(:subject, weekday: "TUESDAY", time: "2", school_code: "1", CFprof: "40", class_code: "1A", name: "storia")
  FactoryBot.create(:subject, weekday: "TUESDAY", time: "3", school_code: "1", CFprof: "999", class_code: "1A", name: "inglese")
  FactoryBot.create(:meeting, id: 9, title: "Meeting con Enzo Esposito", date: DateTime.new(2023, 9, 5, 18, 0, 0), CFprof: "999", CFfamily: "7")
  FactoryBot.create(:school_staff)
end 

Given("I login in a family account") do
  visit root_path
  click_link "Family"
  expect(current_path).to eq(family_login_path)
  @user = Family.all.first
  fill_in 'email-field', with: @user.mail
  fill_in 'password-field', with: @user.password
  click_button 'login-button'
end


And("I am on the family page to choose a student") do
  expect(current_path).to eq(family_choose_path)
end


When("I select the option {string}") do |option_value|
  click_link option_value
end


Then("I should be on the family home page") do
  expect(current_path).to eq(family_home_path)
end

When("I click on the {string} panel") do |panel_name|
  click_link panel_name
end

Then("I should be on the meeting choice page") do
  expect(current_path).to eq(family_meeting_choice_path)
end


When("I select the link {string}") do |full_name|
  name, sur = full_name.split(" ")
  @t = Teacher.find_by(name: name, surname: sur)
  @tcode = @t.CF
  click_link link_id = "#{@tcode}meeting_link"
  
end

Then("I should be on the meeting manage page") do
  
  expect(current_path).to eq(family_meeting_manage_path)
end

When("I book a meeting on {string} {string} at {string}") do |day, month, time|
  @sel = day + month + "_" + time
  find("#" + day + month + "_" + time).click
end

Then("I shoud have that meeting in the booked meeting panel") do 
  id = @sel + "Go"
  expect(page).to have_css("##{id}")
end

When("I delete a meeting") do 
  @deleted_all = Meeting.where(CFprof: @t.CF, CFfamily: @user.CF)
  @del = @deleted_all.first
  @date = @del.date

  @day = @date.strftime("%d")
  @month = @date.strftime("%m")
  @time = @date.hour.to_s
  find("#" + @day + @month + "_" + @time + "Del").click
end

Then("that meeting should not exist anymore") do
  Meeting.find_by(CFprof: @t.CF, CFfamily: @user.CF, date: @date) == nil
end

And("I should have the possibility to book that meeting again") do 
  id = @day + @month + "_" + @time
  expect(page).to have_css("##{id}")
end