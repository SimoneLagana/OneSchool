class CreateNotes < ActiveRecord::Migration[7.0]
  def change
    create_table :notes do |t|
      t.string :CFprof
      t.string :CFstudent
      t.datetime :date
      t.text :description
      t.string :school_code
      t.boolean :justified, default: false
      t.timestamps
    end
  end
end