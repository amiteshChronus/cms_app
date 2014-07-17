class AddIndexToRegistrationsCourseId < ActiveRecord::Migration
  def change
  	add_index :registrations, :course_id
  end
end

