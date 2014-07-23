class Quiz < ActiveRecord::Base
  attr_accessible :name, :questions_attributes
  has_many :questions, :dependent => :destroy
  has_many :attempts, :dependent => :destroy
  belongs_to :course 

  validates :name, presence: true
  validates :questions, presence:true
  
  validates_associated :questions
   
  accepts_nested_attributes_for :questions, :reject_if => lambda {|a| a[:content].blank? }, :allow_destroy => true
  default_scope order: 'quizzes.created_at DESC'
  

end
