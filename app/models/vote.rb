class Vote < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :post
  belongs_to :vote_type
  
end
