class Teacher < User
    validates :birthdate, absence: true
    validates :student_class_code, absence: true
    has_many :commitments

    attribute :first_login, :boolean, default: true

    
      
end
