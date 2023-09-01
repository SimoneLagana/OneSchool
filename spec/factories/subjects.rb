
FactoryBot.define do
    factory :subject do
      weekday { "martedì" }
      time { "2" }
      school_code { "1" }
      CFprof { "40" }
      class_code { "1A" }
      name { "storia" }
    end

    factory :new_subject, class: Subject do
      weekday { "TUESDAY" }
      time { "1" }
      school_code { "1" }
      CFprof { "40" }
      class_code { "1A" }
      name { "storia" }
    end
  end
  