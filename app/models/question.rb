class Question < ActiveRecord::Base
  
  attr_accessible :content
  belongs_to :quiz
  has_many :options
end
