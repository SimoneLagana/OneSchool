Given("every user has mail and password") do
        FactoryBot.create(:school)
        FactoryBot.create(:class_room, class_code: "1A", school_code: "1")
        FactoryBot.create(:class_room, class_code: "1B", school_code: "1")
        FactoryBot.create(:student, name: "Mario", surname: "Rossi", CF: "60", mail: "mario@rossi", password: "passw", school_code: "1", birthdate: DateTime.new(2001,2,3), student_class_code: "1A", student_school_code: "1")
        FactoryBot.create(:student, name: "Simone", surname: "Verdi", CF: "61", mail: "simone@verdi", password: "simonepas", school_code: "1", birthdate: DateTime.new(2008,2,3), student_class_code: "1A", student_school_code: "1")
        FactoryBot.create(:family, name: "Maria", surname: "Rossi", CF: "7", mail: "maria@Rossi", password: "samir", school_code: "1")
        FactoryBot.create(:family_student, id: 1, CFfamily: "7", CFstudent: "60", school_code: "1")
        FactoryBot.create(:teacher, name: "Luigi", surname: "Colombo", CF: "40", mail: "luigi@colomboi", password: "pas", school_code: "1")
        FactoryBot.create(:subject, weekday: "martedì", time: "2", school_code: "1", CFprof: "40", class_code: "1A", name: "storia")
        FactoryBot.create(:meeting, id: 9, title: "Meeting con Enzo Esposito", date: DateTime.new(2023, 8, 30, 18, 0, 0), CFprof: "40", CFfamily: "7")
        FactoryBot.create(:school_staff)
        FactoryBot.create(:home1)
    end

    
    Given("I login as a student") do
        visit root_path
        click_link "Student"
        expect(current_path).to eq(student_login_path)
        @user = Student.all.first
        fill_in 'email-field', with: @user.mail
        fill_in 'password-field', with: @user.password
        click_button 'login-button'
    end

    Then("I should be on my student home page") do
        expect(current_path).to eq(student_home_path)
    end

    When("I choose the panel {string}") do |pan|
        click_link pan
    end

    Then("I should be on the homework page") do
        expect(current_path).to eq(student_homework_path)
        puts page.body
    end