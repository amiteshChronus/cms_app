class Option < ActiveRecord::Base
  attr_accessible :correct, :description, :question_id
  belongs_to :question 
  
  validates :description, presence: true
  


end
