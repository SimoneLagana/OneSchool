Given("the user is on the page {string}") do |page|
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
      visit student_prova_path
  end
  
  When("the user clicks the {string} button in the form") do |button_text|
    puts page.body
  end
  
  Then("the user is directed to the page index") do 
    click_button "be"
  end
  