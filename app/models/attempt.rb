class Attempt < ActiveRecord::Base
  attr_accessible :marks, :quiz_id, :student_id
  belongs_to :quiz
  belongs_to :user

end
