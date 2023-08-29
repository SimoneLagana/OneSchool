# spec/factories/users.rb

FactoryBot.define do
    factory :student, class: User do
      name { 'Mario' }
      surname { 'Rossi' }
      CF { '60' } # Puoi inserire un valore univoco o generarlo in modo casuale
      mail { 'mario@rossi' }
      password { 'passw' }
      school_code { '1' }
      type { 'Student' }
  
      # Altri attributi specifici dell'utente studente
      birthdate { DateTime.new(2001, 2, 3) }
      student_class_code { '1A' }
      student_school_code { '1' }
    end

    factory :teacher, class: User do
      # Definizione della factory per Teacher
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
      CF { '7' } # Puoi inserire un valore univoco o generarlo in modo casuale
      mail { 'maria@Rossi' }
      password { 'samir' }
      school_code { '1' }
      type { 'Family' }
    end
    
  end
  