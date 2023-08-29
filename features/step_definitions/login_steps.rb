Given("the user is on the login page") do
  visit "/student/login"
end

When("the user fills in {string} in the mail field") do |email|
  fill_in "mail", with: email
  $email = email
end

And("fills in {string} in the password field") do |password|
  fill_in "password", with: password
end

And("clicks the {string} button") do |button_text|
  click_button(button_text)
 
  student_info = { mail: $email, islogged: true }
  
  cook = { value: student_info.to_json, expires: 30.day.from_now }
  #page.driver.browser.set_cookie("student_info=#{cook}")
  page.driver.browser.set_cookie("student_info=#{cook.to_json}")
  puts Capybara.current_session.driver.request.cookies['auth_token']
end



Then('the user is directed to the {string} page') do |page_path|
  expect(current_path).to eq(page_path)
end


