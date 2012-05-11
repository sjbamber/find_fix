class Comment < ActiveRecord::Base

  belongs_to :user
  belongs_to :post
  belongs_to :solution
  has_many :votes
  
  validates_presence_of :comment, :user
  validates_length_of :comment, :maximum => 255
  validate :contains_one_post
  
  # define the callbacks to update the index upon saving and deleting records
  after_save :update_post_index
  after_destroy :update_post_index
  
  def get_score
    positive_vote_count = self.votes.joins(:vote_type).where('vote_types.name' => 'positive').count
    negative_vote_count = self.votes.joins(:vote_type).where('vote_types.name' => 'negative').count
    return positive_vote_count - negative_vote_count
  end
  
  private
  
  def update_post_index
    if post
      Tanker.batch_update([post])
    elsif solution
      Tanker.batch_update([solution.post])
    end
  end 
  
  def contains_one_post
    unless [self.post_id, self.solution_id].compact.size == 1
      self.errors.add(:base, "A comment must be associated with a problem or solution")
    end
  end
end
