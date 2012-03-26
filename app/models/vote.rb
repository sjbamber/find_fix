class Vote < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :post
  belongs_to :solution
  belongs_to :comment
  belongs_to :vote_type
  
  validates_presence_of :vote_type_id
  validates_presence_of :user_id
  
end
