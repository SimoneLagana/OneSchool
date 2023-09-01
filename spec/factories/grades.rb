FactoryBot.define do
    factory :grade_1, class: Grade do
        CFprof { "40" }
        CFstudent { "60" }
        date { DateTime.new(2023, 9, 12, 0, 0, 0) }
        school_code { "1" }
        class_code {"1A"}
        subject_name {"storia"}
        weekday {"TUESDAY"}
        time {"1"}
        value {8}
      end
    end