class CreateFamilyStudents < ActiveRecord::Migration[7.0]
  def change
    create_table :family_students do |t|
      t.string :CFfamily
      t.string :CFstudent
      t.string :school_code

      t.timestamps
    end
  end
end