class VoteType < ActiveRecord::Base
  
  has_many :votes
  
end
