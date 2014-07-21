class Question < ActiveRecord::Base
  attr_accessible :content, :quiz_id, :options_attributes
  belongs_to :quiz
  has_many :options, :dependent => :destroy
  accepts_nested_attributes_for :options, :reject_if => lambda {|a| a[:description].blank?}, :allow_destroy => true

end
