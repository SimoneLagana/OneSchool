class AddForeignKey < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :users, :schools, column: :school_code, primary_key: :code
    #add_index :users, [:student_class_code, :student_school_code]
    #add_foreign_key :users, :class_rooms, column: :student_school_code, primary_key: [:class_code,:school_code]
    #add_foreign_key :users, :class_rooms, column: :student_class_code, primary_key: [:class_code, :school_code]
    #add_index :class_rooms, [:school_code, :class_code], unique: true
    add_foreign_key :class_rooms, :schools, column: :school_code, primary_key: :code
    add_foreign_key :family_students, :users, column: :CFfamily, primary_key: :CF
    add_foreign_key :family_students, :users, column: :CFstudent, primary_key: :CF
    add_foreign_key :commitments, :users, column: :CFprof, primary_key: :CF
    add_foreign_key :commitments, :users, column: :CFfamily, primary_key: :CF
    add_foreign_key :subjects, :users, column: :CFprof, primary_key: :CF
    add_foreign_key :notes, :users, column: :CFprof, primary_key: :CF
    add_foreign_key :notes, :users, column: :CFstudent, primary_key: :CF
    add_foreign_key :grades, :users, column: :CFstudent, primary_key: :CF
    add_foreign_key :grades, :users, column: :CFprof, primary_key: :CF
    add_foreign_key :absences, :users, column: :CFstudent, primary_key: :CF
    add_foreign_key :absences, :users, column: :CFprof, primary_key: :CF
    add_foreign_key :homeworks, :users, column: :CFprof, primary_key: :CF
    #add_index :subjects, [:school_code, :class_code, :name,:weekday, :time ], unique: true
    add_index :subjects, [:school_code, :class_code, :weekday, :time], unique: true, name: 'index2'
  end
end
