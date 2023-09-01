Given("I am a school staff user") do 
  FactoryBot.create(:school)
  FactoryBot.create(:class_room)
  FactoryBot.create(:school_staff)
end

And("my mail is {string}") do |mail|
  @mail = mail
end

And("my password is {string}") do |pas|
  @password = pas
end

Given("I am in the main page") do
  visit root_path
end 

When("I click on the panel {string}") do |panel_name|
    click_link panel_name
end

Then("I should be in the staff login page") do 
  expect(current_path).to eq(school_staff_login_path)
end

When("I put my mail in the mail field") do 
  fill_in 'email-field', with: @mail
end

When("I put my password in the field password") do
  fill_in 'password-field', with: @password
 
end

And("I press the button to login") do
  click_button 'login-button' 
end

Then("I should be in the school staff home page") do 
  expect(current_path).to eq(school_staff_home_path)
end

When("I put the mail {string}") do |mail|
  fill_in 'email-field', with: mail
end

And("I should get the alert {string}") do |alert|
  expect(page).to have_content(alert)
end

And("I put the password {string}") do |pass|
  fill_in 'password-field', with: pass
end