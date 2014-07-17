class Course < ActiveRecord::Base
  attr_accessible :description, :name

  
  has_many :quizzes
  has_many :offerings, dependent: :destroy
  has_many :registrations, foreign_key: "course_id", dependent: :destroy
  has_many :students, :through => :registrations, :source => :student
  # has_many :students, through: :registrations, source: :student
  has_many :instructors, through: :offerings, source: :instructor
 end