# spec/factories/schools.rb

FactoryBot.define do
    factory :meeting do
      id { 9 }
      title { "Meeting con Enzo Esposito" }
      date { DateTime.new(2023, 8, 30, 19, 0, 0) }
      CFprof { "40" }
      CFfamily { "7" }
      link {"http://localhost:8000/meeting"}
    end
  end
  