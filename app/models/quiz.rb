class Quiz < ActiveRecord::Base
  attr_accessible :name
  has_many :questions, :dependent => :destroy
  has_many :attempts, :dependent => :destroy
  belongs_to :course, :dependent => :destroy

  accepts_nested_attributes_for :questions, :reject_if => :all_blank, :allow_destroy => true
end
