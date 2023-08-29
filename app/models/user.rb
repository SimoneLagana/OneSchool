class User < ApplicationRecord
    devise :omniauthable, omniauth_providers: [:google_oauth2]

    belongs_to :school, foreign_key: 'school_code', primary_key: 'code'
    has_many :family_student, foreign_key: 'CFfamily', primary_key: 'CF'
    has_many :family_student, foreign_key: 'CFstudent', primary_key: 'CF'
    has_many :commitments, foreign_key: 'CFprof', primary_key: 'CF'
    has_many :commitments, foreign_key: 'CFfamily', primary_key: 'CF'
    has_many :subjects, foreign_key: 'CFprof', primary_key: 'CF'
    has_many :notes, foreign_key: 'CFprof', primary_key: 'CF'
    has_many :notes, foreign_key: 'CFstudent', primary_key: 'CF'
    has_many :grades, foreign_key: 'CFstudent', primary_key: 'CF'
    has_many :grades, foreign_key: 'CFprof', primary_key: 'CF'
    has_many :absences, foreign_key: 'CFstudent', primary_key: 'CF'
    has_many :absences, foreign_key: 'CFprof', primary_key: 'CF'
    has_many :homeworks, foreign_key: 'CFprof', primary_key: 'CF'
    validates :name, presence: true
    validates :surname, presence: true
    validates :CF, presence: true, uniqueness: true
    validates :mail, presence: true, uniqueness: true
    validates :password, presence: true

    def self.from_omniauth(auth)
        where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
          user.email = auth.info.email
          user.password = Devise.friendly_token[0, 20]
          user.full_name = auth.info.name # assuming the user model has a name
          # If you are using confirmable and the provider(s) you use validate emails,
          # uncomment the line below to skip the confirmation emails.
          # user.skip_confirmation!
        end
      end
    
end
