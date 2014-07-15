class Course < ActiveRecord::Base
  attr_accessible :description, :instructor_id, :name

  
  has_many :quizzes
  has_many :offerings, dependent: :destroy
  has_many :registrations, dependent: :destroy
  has_many :students, through: :registrations, source: :student_id
  belongs_to :instructors, through: :offerings, source: :instructor_id