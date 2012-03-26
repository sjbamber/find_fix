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
  accepts_nested_attributes_for :tags, :categories, :reject_if => lambda {|a| a[:name].blank?}
  accepts_nested_attributes_for :error_messages, :reject_if => lambda {|a| a[:description].blank?}
  accepts_nested_attributes_for :comments, :votes

  # Validation
  validates_presence_of :title, :description
  validates_length_of :title, :maximum => 255
  # Validations for tags and categories only if validated_nested
  validates_presence_of :tags, :if => :validate_nested
  validates_presence_of :categories, :if => :validate_nested
  # Perform associated validation on nested attribute models
  validates_associated :tags, :categories, :error_messages
  
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
    indexes :title
    indexes :description
    indexes :list_error_messages
    indexes :list_categories
    indexes :list_tags
    indexes :list_solutions
    indexes :list_comments
    
    # Variables available in scoring function
    variables do
      {
      }
    end
    
    # Scoring functions that can be
    # referenced in your queries. 
    # They're always referenced by their integer key:
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
  
  # Process nested attributes into a flat string for use in the search index
  def list_error_messages
    list = ""
    error_messages.each do |e|
      list += e.description + " "
    end
    return list.strip
  end

  def list_categories
    list = ""
    categories.each do |c|
      list += c.name + " "
    end
    return list.strip
  end

  def list_tags
    list = ""
    tags.each do |t|
      list += t.name + " "
    end
    return list.strip
  end
  
  def list_solutions
    list = ""
    solutions.each do |s|
      list += s.description + " "
    end
    return list.strip
  end
  
  def list_comments
    list = ""
    comments.each do |pc|
      list += pc.comment + " "
    end
    solutions.each do |s|
      s.comments.each do |sc|
          list += sc.comment + " "
      end
    end
    return list.strip
  end
  
end
