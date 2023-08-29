# Assuming you have a step_definitions directory where you keep your step definition files

# step_definitions/family_dashboard_steps.rb
Given("there is a family with email and password") do
  FactoryBot.create(:school)
  FactoryBot.create(:class_room)
  FactoryBot.create(:student, name: "Mario", surname: "Rossi", CF: "60", mail: "mario@rossi", password: "passw", school_code: "1", birthdate: DateTime.new(2001,2,3), student_class_code: "1A", student_school_code: "1")
  FactoryBot.create(:family, name: "Maria", surname: "Rossi", CF: "7", mail: "maria@Rossi", password: "samir", school_code: "1")
  FactoryBot.create(:family_student, id: 1, CFfamily: "7", CFstudent: "60", school_code: "1")
  FactoryBot.create(:teacher, name: "Luigi", surname: "Colombo", CF: "40", mail: "luigi@colombo", password: "pas", school_code: "1")
  FactoryBot.create(:subject, weekday: "TUESDAY", time: "3", school_code: "1", CFprof: "40", class_code: "1A", name: "storia")

end

When("I visit the family login page") do
  visit family_login_path
end

And("I fill in email field with {string}") do |value|
  fill_in 'email-field', with: value
end

And("I fill in password field with {string}") do |value|
  fill_in 'password-field', with: value
end

And("I click login button") do
  click_button 'login-button'
end

Given("I am on the family page to choose a student") do
  expect(current_path).to eq(family_choose_path)
end

# step_definitions/meeting_steps.rb
# When("I choose a student at index {int}") do |index|
#   student_link = all(".student-link")[index]
#   student_link.wait_for_present
#   student_link.click
# end
# step_definitions/meeting_steps.rb
When("I select the option {string}") do |option_value|
  find("#" + option_value).click
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

# In your step definition file (e.g., meeting_steps.rb)
When("I select Luigi Colombo") do
  find("#40meeting_link").click
end


Then("I should be on the meeting manage page") do
  
  expect(current_path).to eq(family_meeting_manage_path)
end

When("I book a meeting on {string} {string} at {string}") do |day, month, time|
  puts "#" + day + month + "_" + time
  find("#" + day + month + "_" + time).click
  puts page.body
end

Then("I shoud have a meeting booked on {string} {string} at {string}") do |day, month, time|
  id = day + month + "_" + time + "Go"
  expect(page).to have_css("##{id}")
end