class Solution < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :post
  has_many :comments
  has_many :votes
  
  validates_presence_of :description, :user, :post
  
  attr_accessor :score
  
  # define the callbacks to update the index upon saving and deleting records
  after_save :update_post_index
  after_destroy :update_post_index
  
  scope :sorted_by_score, order("posts.updated_at DESC")  

  def get_score
    positive_vote_count = self.votes.joins(:vote_type).where('vote_types.name' => 'positive').count
    negative_vote_count = self.votes.joins(:vote_type).where('vote_types.name' => 'negative').count
    return positive_vote_count - negative_vote_count
  end
 
  private
  
  def update_post_index
    Tanker.batch_update([post])
  end
  
end
