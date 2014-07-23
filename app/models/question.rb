class Question < ActiveRecord::Base
  attr_accessible :content, :quiz_id, :options_attributes
  validate do
  	no_correct
  end
  belongs_to :quiz
  has_many :options, :dependent => :destroy 
  accepts_nested_attributes_for :options, :reject_if => lambda {|a| a[:description].blank?}, :allow_destroy => true

  private

  def no_correct
  	unless no_options?
  		errors.add(:options, "cannot be all false")
  	end
  end	
  def no_options?
	flag=false
  	self.options.each do |option|
  		flag= flag || option.correct
  	end
  	flag
  end
  
end
