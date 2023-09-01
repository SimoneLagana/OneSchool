    Given("there is a school staff user with mail and password") do
        FactoryBot.create(:school)
        FactoryBot.create(:class_room, class_code: "1A", school_code: "1")
        FactoryBot.create(:class_room, class_code: "1B", school_code: "1")
        FactoryBot.create(:student, name: "Mario", surname: "Rossi", CF: "60", mail: "mario@rossi", password: "passw", school_code: "1", birthdate: DateTime.new(2001,2,3), student_class_code: "1A", student_school_code: "1")
        FactoryBot.create(:student, name: "Simone", surname: "Verdi", CF: "61", mail: "simone@verdi", password: "simonepas", school_code: "1", birthdate: DateTime.new(2008,2,3), student_class_code: "1A", student_school_code: "1")
        FactoryBot.create(:family, name: "Maria", surname: "Rossi", CF: "7", mail: "maria@Rossi", password: "samir", school_code: "1")
        FactoryBot.create(:family_student, id: 1, CFfamily: "7", CFstudent: "60", school_code: "1")
        FactoryBot.create(:teacher, name: "Luigi", surname: "Colombo", CF: "40", mail: "luigi@colomboi", password: "pas", school_code: "1")
        FactoryBot.create(:subject, weekday: "TUESDAY", time: "2", school_code: "1", CFprof: "40", class_code: "1A", name: "storia")
        FactoryBot.create(:meeting, id: 9, title: "Meeting con Enzo Esposito", date: DateTime.new(2023, 8, 30, 18, 0, 0), CFprof: "40", CFfamily: "7")
        FactoryBot.create(:school_staff)
    end

    
    Given("I login as a school staff user") do
        visit root_path
        click_link "Schoolstaff"
        expect(current_path).to eq(school_staff_login_path)
        @user = SchoolStaff.all.first
        fill_in 'email-field', with: @user.mail
        fill_in 'password-field', with: @user.password
        click_button 'login-button'
    end

    Then("I should be on the school staff home page") do
        expect(current_path).to eq(school_staff_home_path)
    end

    When("I select {string}") do |panel|
        click_link panel
    end

    Then("I should be on the page to manage ClassRooms") do
        expect(current_path).to eq(school_staff_class_manage_path)
    end

    When("I search for a class") do
        @class = ClassRoom.all.first
        @code = @class.class_code
        fill_in "searchfield", with: @class.class_code
      end

    And("I press {string} for the same class in the list") do |btn|
        delete_button = find("##{btn}#{@class.class_code}")
        delete_button.click
    end   

    Then("I should not have that class anymore") do 
        @int = ClassRoom.find_by(class_code: @code, school_code: "1")
        puts "la nuova classe è #{@int}" 
        expect(@int).to be_nil
      end

      Then("I should have a popup open") do
        puts page.body
      end
  

      And("I press {string}") do |btn|
        delete_button = find("##{btn}")
        delete_button.click
    end 