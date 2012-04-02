class Solution < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :post
  has_many :comments
  has_many :votes
  
  validates_presence_of :description
  
  # define the callbacks to update the index upon saving and deleting records
  after_save :update_post_index
  after_destroy :update_post_index
  
  private
  
  def update_post_index
    Tanker.batch_update([post])
  end
end
