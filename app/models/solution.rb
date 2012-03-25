class Solution < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :post
  has_many :comments
  
  validates_presence_of :description
  
end
