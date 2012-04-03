class VoteType < ActiveRecord::Base
  
  has_many :votes
  
  validates_presence_of :name
  validates_length_of :name, :maximum => 30
  
end
