class Offering < ActiveRecord::Base
  attr_accessible :course_id, :instructor_id
  belongs_to :course , dependent: :destroy
  belongs_to :instructor, class_name: "User"
end
