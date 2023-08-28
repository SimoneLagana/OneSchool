Given("I am logged in as a student") do 
    # Crea uno studente di prova con le credenziali specificate
    FactoryBot.create(:school)
    FactoryBot.create(:class_room)
    FactoryBot.create(:student, name: "Mario", surname: "Rossi", CF: "60", mail: "mario@rossi", password: "passw", school_code: "1", birthdate: DateTime.new(2001,2,3), student_class_code: "1A", student_school_code: "1")
    visit student_login_path
    fill_in 'email-field', with: "mario@rossi"
    fill_in 'password-field', with: "passw"
    click_button 'login-button'
    expect(current_path).to eq(student_home_path)
end

And("there is an homework") do 
    FactoryBot.create(:teacher)
  end