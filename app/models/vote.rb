class Vote < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :post
  belongs_to :solution
  belongs_to :comment
  belongs_to :vote_type
  
  validates_presence_of :vote_type_id
  validates_presence_of :user_id
  validate :contains_one_post
  
  private
  
  def contains_one_post
    unless [self.post_id, self.solution_id, self.comment_id].compact.size == 1
      self.errors.add(:base, "A vote must contain exactly one post (problem, solution or comment)")
    end
  end
  
end
