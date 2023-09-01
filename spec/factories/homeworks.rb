FactoryBot.define do
    factory :home1, class: Homework do 
      delivered { false }
      text { "saggio breve" }
      date { DateTime.new(2023, 9, 15, 0,0,0) }
      name { "saggio" }
      time { "2" }
      weekday { "martedì" }
      school_code { "1" }
      class_code { "1A" }
      CFprof { "40" }
      subject_name { "storia" }
    end
  end
  