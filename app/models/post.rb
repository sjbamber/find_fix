class Post < ActiveRecord::Base
  
  # include the Tanker module for search using IndexTank
  include Tanker
  
  # Relationships
  belongs_to :user
  has_many :solutions
  has_many :comments
  has_many :votes
  has_many :post_tags
  has_many :tags, :through => :post_tags
  has_many :post_categories
  has_many :categories, :through => :post_categories
  has_many :post_error_messages
  has_many :error_messages, :through => :post_error_messages
  
  # Non-active record attribute to enable validation on nested attributes
  attr_accessor :validate_nested
  
  # Accept nested attributes, enables nested assignment using fields for
  # :reject_if => lambda {|a| a[:name].blank?} # ignores blank entries
  accepts_nested_attributes_for :tags, :reject_if => lambda {|a| a[:name].blank?}, :allow_destroy => true
  accepts_nested_attributes_for :categories, :reject_if => lambda {|a| a[:name].blank?}, :allow_destroy => true
  accepts_nested_attributes_for :error_messages, :reject_if => lambda {|a| a[:description].blank?}, :allow_destroy => true
  accepts_nested_attributes_for :comments, :votes
  # The generated nested attributes are required for mass assignment
  attr_accessible :title, :description, :error_messages_attributes, :categories_attributes, :tags_attributes

  # Validation
  validates_presence_of :title, :description
  validates_length_of :title, :maximum => 255
  # Validations for tags and categories only if validated_nested
  validates_presence_of :tags, :if => :validate_nested
  validates_presence_of :categories, :if => :validate_nested
  # Perform associated validation on nested attribute models
  validates_associated :tags, :categories, :error_messages
  # Checks if the limit of nested attributes has been exceeded
  validate :maximum_nested_attributes
  
  # Sets pagination value for listed posts
  self.per_page = 10
  
  # Custom Scopes for sort and search
  scope :sorted, order("posts.updated_at DESC")  
  scope :search, lambda {|query| where(["description LIKE ? OR title LIKE ?", "%#{query}%", "%#{query}%"])}

  # Index post data for search
  if ENV['RAILS_ENV'] === "production"
    index = 'idx'
  else
    index = 'test'
  end
  
  tankit index do
  # Index values for search purposes
    indexes :title
    indexes :description
    # index nested values
    indexes :error_message_descriptions do
      error_messages.map {|error_message| error_message.description }
    end
    indexes :category_names do
      categories.map {|category| category.name }
    end
    indexes :tag_names do
      tags.map {|tag| tag.name }
    end
    indexes :solution_descriptions do
      solutions.map {|solution| solution.description }
    end
    indexes :post_comments do
      comments.map {|comment| comment.comment }
    end
    indexes :solutions_comments do
      # Gets a list of all comments on nested solutions, reject is required to remove blank array elements generated
      solutions.map {|solution| solution.comments.map {|comment| comment.comment}}.reject{ |c| c.empty? }
    end
    
    # Index values for display purposes
    indexes :updated_at
    indexes :user_id
    
    # Variables available in scoring function
    variables do
      {
        0 => solutions.count, # number of solutions in a post
        1 => comments.count   # number of comments in a post
      }
    end
    
    # Scoring functions
    functions do
      {
        0 => 'relevance',
        1 => '-age'
      }
    end
    
  end
  
  # define the callbacks to update or delete the index upon saving and deleting records
  after_save :update_tank_indexes
  after_destroy :delete_tank_indexes
  
  private

  # Validation methods for nested attributes
  def maximum_nested_attributes
    if self.categories.size > 5
      self.errors.add(:base, "A problem can only contain a maximum of 4 categories")
    end
    if self.error_messages.size > 4
      self.errors.add(:base, "A problem can only contain a maximum of 4 error messages")
    end
    if self.tags.size > 5
      self.errors.add(:base, "A problem can only contain a maximum of 5 tags")
    end        
  end
  
  
end
