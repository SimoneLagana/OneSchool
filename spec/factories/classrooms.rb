# spec/factories/classrooms.rb

FactoryBot.define do
    factory :class_room do
      class_code { "1A" }
      school_code { "1" }
    end
  end
  