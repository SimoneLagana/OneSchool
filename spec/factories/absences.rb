
FactoryBot.define do
    factory :absence do
      CFprof { "40" }
      CFstudent { "60" }
      date { DateTime.new(2023, 8, 9, 0, 0, 0) }
      school_code { "1" }
      class_code {"1A"}
      subject_name {"storia"}
      weekday {"martedì"}
      time {"1"}
      justified {false}
    end

    factory :absence_j, class: Absence do
      CFprof { "40" }
      CFstudent { "60" }
      date { DateTime.new(2023, 8, 2, 0, 0, 0) }
      school_code { "1" }
      class_code {"1A"}
      subject_name {"storia"}
      weekday {"martedì"} 
      time {"1"}
      justified {true}
    end

    factory :absence_sv, class: Absence do
      CFprof { "40" }
      CFstudent { "61" }
      date { DateTime.new(2023, 8, 2, 0, 0, 0) }
      school_code { "1" }
      class_code {"1A"}
      subject_name {"storia"}
      weekday {"martedì"}
      time {"1"}
      justified {false}
    end

    factory :absence_sv_j, class: Absence do
      CFprof { "40" }
      CFstudent { "61" }
      date { DateTime.new(2023, 8, 9, 0, 0, 0) }
      school_code { "1" }
      class_code {"1A"}
      subject_name {"storia"}
      weekday {"martedì"}
      time {"1"}
      justified {true}
    end

    
    

    

  end