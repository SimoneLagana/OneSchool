class ClassRoom < ApplicationRecord
    belongs_to :school, foreign_key: 'school_code', primary_key: 'code'
    has_many :students, foreign_key: ['class_code', 'school_code'], primary_key: ['class_code', 'school_code']
    
end