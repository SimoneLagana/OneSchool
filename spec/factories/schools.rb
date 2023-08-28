# spec/factories/schools.rb

FactoryBot.define do
    factory :school do
      address { "Via Roma" }
      name { "Spallanzani" }
      code { "1" }
      school_type { "liceo" }
    end
  end
  