class Comment < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :post
  belongs_to :solution
  
  validates_presence_of :comment
  validates_length_of :comment, :maximum => 255
  
end
