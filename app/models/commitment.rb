class Commitment < ApplicationRecord
    belongs_to :users, foreign_key: 'CFfamily', primary_key: 'CF', class_name: "User"
    belongs_to :users, foreign_key: 'CFprof', primary_key: 'CF', class_name: "User"
    #self.primary_key = :id
    validates :CFprof, presence: true
    validates :date, presence: true


end