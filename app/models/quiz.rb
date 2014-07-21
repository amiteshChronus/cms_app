class Quiz < ActiveRecord::Base
  attr_accessible :name, :questions_attributes
  has_many :questions, :dependent => :destroy
  has_many :attempts, :dependent => :destroy
  belongs_to :course 

  accepts_nested_attributes_for :questions, :reject_if => lambda {|a| a[:content].blank? }, :allow_destroy => true
  default_scope order: 'quizzes.created_at DESC'
end
