# spec/factories/users.rb

FactoryBot.define do
    factory :student, class: User do
      name { 'Mario' }
      surname { 'Rossi' }
      CF { '60' } 
      mail { 'mario@rossi' }
      password { 'passw' }
      school_code { '1' }
      type { 'Student' }
  
      
      birthdate { DateTime.new(2001, 2, 3) }
      student_class_code { '1A' }
      student_school_code { '1' }
    end

    factory :teacher, class: User do
      
      name { 'Luigi' }
      surname { 'Colombo' }
      CF { '40' }
      mail { 'luigi@colombo' }
      password { 'pas' }
      school_code { '1' }
      type { 'Teacher' }
    end

    
    
    factory :family, class: User do
      name { 'Maria' }
      surname { 'Rossi' }
      CF { '7' } 
      mail { 'maria@Rossi' }
      password { 'pas' }
      school_code { '1' }
      type { 'Family' }
    end

    factory :school_staff, class: User do
      name { 'Aldo' }
      surname { 'Moro' }
      CF { '55' } 
      mail { 'aldo@moro' }
      password { 'pas' }
      school_code { '1' }
      type { 'SchoolStaff' }
    end
    
  end
  