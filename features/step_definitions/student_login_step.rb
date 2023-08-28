Given("there is a student with email and password") do 
    # Crea uno studente di prova con le credenziali specificate
    FactoryBot.create(:school)
    FactoryBot.create(:class_room)
    FactoryBot.create(:student, name: "Mario", surname: "Rossi", CF: "60", mail: "mario@rossi", password: "passw", school_code: "1", birthdate: DateTime.new(2001,2,3), student_class_code: "1A", student_school_code: "1")
  end
  
  When("I visit the student login page") do
    visit student_login_path
  end
  
  And("I fill in email with {string}") do |value|
    fill_in 'email-field', with: value
  end

  And("I fill in password with {string}") do |value|
    fill_in 'password-field', with: value
  end
  
  And("I click the login button") do
    click_button 'login-button'
  end
  
  Then("I should be on the student home page") do
    expect(current_path).to eq(student_home_path)
  end
  
  And("I should see {string}") do |text|
    expect(page).to have_content(text)
  end