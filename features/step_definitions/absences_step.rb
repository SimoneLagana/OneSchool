Given("there is a user with mail and password") do
    FactoryBot.create(:school)
    FactoryBot.create(:class_room, class_code: "1A", school_code: "1")
    FactoryBot.create(:student, name: "Mario", surname: "Rossi", CF: "60", mail: "mario@rossi", password: "passw", school_code: "1", birthdate: DateTime.new(2001,2,3), student_class_code: "1A", student_school_code: "1")
    FactoryBot.create(:student, name: "Simone", surname: "Verdi", CF: "61", mail: "simone@verdi", password: "simonepas", school_code: "1", birthdate: DateTime.new(2008,2,3), student_class_code: "1A", student_school_code: "1")
    FactoryBot.create(:family, name: "Maria", surname: "Rossi", CF: "7", mail: "maria@Rossi", password: "pas", school_code: "1")
    FactoryBot.create(:family, name: "Paolo", surname: "Verdi", CF: "8", mail: "paolo@verdi", password: "pas", school_code: "1")

    FactoryBot.create(:family_student, id: 1, CFfamily: "7", CFstudent: "60", school_code: "1")
    FactoryBot.create(:family_student, id: 2, CFfamily: "7", CFstudent: "61", school_code: "1")
    FactoryBot.create(:family_student, id: 3, CFfamily: "8", CFstudent: "61", school_code: "1")

    FactoryBot.create(:teacher, name: "Luigi", surname: "Colombo", CF: "40", mail: "luigi@colomboi", password: "pas", school_code: "1")
    FactoryBot.create(:subject, weekday: "martedì", time: "2", school_code: "1", CFprof: "40", class_code: "1A", name: "storia")
    FactoryBot.create(:meeting, id: 9, title: "Meeting con Enzo Esposito", date: DateTime.new(2023, 8, 30, 18, 0, 0), CFprof: "40", CFfamily: "7")
    FactoryBot.create(:absence)
    FactoryBot.create(:absence_j)
    FactoryBot.create(:absence_sv)
    FactoryBot.create(:absence_sv_j)
  end
  

  Given("I login as an adult student") do
    visit root_path
    click_link "Student"
    expect(current_path).to eq(student_login_path)
    @user = Student.find_by(CF: "60")
    fill_in 'email-field', with: @user.mail
    fill_in 'password-field', with: @user.password
    click_button 'login-button'
  end

  And("I am in the student home page") do
    expect(current_path).to eq(student_home_path)
  end

  When("I select the panel {string}") do |panel|
    click_link panel
  end

  Then("I should be in the student absences page") do
    expect(current_path).to eq(student_absence_path)
  end

  When("I search for an absence that is not justified") do 
    @ab = Absence.where(CFstudent: @user.CF, justified: false)
    @first = @ab.first
  end

  And("I select the corrisponding button to justify") do
    @id = @first.id.to_s
    click_button @id
  end

  Then("the absence should be justified") do
    @first.justified == true
  end

  When("I search for an absence that already justified") do
    @ab = Absence.where(CFstudent: @user.CF, justified: true)
    @first = @ab.first
  end

  Then("I should not have a button to justify it") do
    @id= @first.id.to_s
    expect(page).not_to have_selector("#" + @id)
  end



  Given("I login as a not adult student") do
    visit root_path
    click_link "Student"
    expect(current_path).to eq(student_login_path)
    @user = Student.find_by(CF: "61")
    fill_in 'email-field', with: @user.mail
    fill_in 'password-field', with: @user.password
    click_button 'login-button'
  end


  Given("I login as a parent with more than a child") do 
    visit root_path
    click_link "Family"
    expect(current_path).to eq(family_login_path)
    @family = Family.find_by(CF: "7")
    fill_in 'email-field', with: @family.mail
    fill_in 'password-field', with: @family.password
    click_button 'login-button'
    expect(current_path).to eq(family_choose_path)
  end

   And("I choose one of my children") do
    @family_children = FamilyStudent.where(CFfamily: @family.CF)
    @first_family = @family_children.first
    @user = Student.find_by(CF: @first_family.CFstudent)
    @CF = @user.CF.to_s
    find("#" + @CF).click
   end

   Then("I am in the child home page") do
    expect(current_path).to eq(family_home_path)
   end

   And("I should be in the child absences page") do
    expect(current_path).to eq(family_absences_path)
   end

   