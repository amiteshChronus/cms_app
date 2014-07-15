class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation, :role
  has_secure_password

  
  has_many :offerings, foreign_key: "instructor_id", dependent: :destroy
  has_many :registrations, foreign_key: "student_id", dependent: :destroy

  has_many :offered_courses, through: :offerings
  has_many :registered_courses, through: :registrations
  
  has_many :attempts


  before_save { |user| user.email = email.downcase }
  validate :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, 
  					uniqueness: {case_sensitive: false}

 	validates :password, presence: true
 	validates :password_confirmation, presence:true
 	validates :role, presence: true
end
