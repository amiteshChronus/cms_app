class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation, :role, :remember_token
  before_create {generate_token(:remember_token)}
  has_secure_password

  before_save { |user| user.email = email.downcase }
  
  
  has_many :offerings, foreign_key: "instructor_id", dependent: :destroy
  has_many :registrations, foreign_key: "student_id", dependent: :destroy

  has_many :offered_courses, through: :offerings , source: :course
  has_many :registered_courses, through: :registrations, source: :course
  has_many :attempts, foreign_key: "student_id", dependent: :destroy

  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, 
  					uniqueness: {case_sensitive: false}

 	validates :password, presence: true
 	validates :password_confirmation, presence:true
 	validates :role, presence: true



  def registered?(course)
    registrations.find_by_course_id(course.id)
  end

  def register!(course)
    registrations.create!(course_id: course.id)
  end

  def unregister!(course)
    registrations.find_by_course_id(course.id).destroy
  end

  def generate_token(column)
      begin
        self[column] = SecureRandom.urlsafe_base64
      end while User.exists?(column => self[column])
  end

  def send_password_reset
      generate_token(:password_reset_token)
      self.password_reset_sent_at = Time.zone.now
      save!(validate: false)
      Emailer.password_reset(self).deliver
  end
  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

    


end
