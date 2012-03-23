class Solution < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :post
  
  validates_presence_of :description
  
end
