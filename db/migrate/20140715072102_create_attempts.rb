class CreateAttempts < ActiveRecord::Migration
  def change
    create_table :attempts do |t|
      t.integer :quiz_id
      t.integer :student_id
      t.integer :marks

      t.timestamps
    end
  end
end
