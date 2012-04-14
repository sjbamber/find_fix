class Tag < ActiveRecord::Base
 
  # include the Tanker module for search using IndexTank
  include Tanker
  
  has_many :post_tags
  has_many :posts, :through => :post_tags
  
  has_many :tag_ownerships
  has_many :owners, :through => :tag_ownerships, :class_name => "User"
  
  validates_presence_of  :name, :message => "At least one tag must be entered"
  with_options :allow_blank => true do |v|
    v.validates_length_of :name, { :within => 3..100 }
  end

  # Index data for search
  if ENV['RAILS_ENV'] === "production"
    index = 'idx'
  else
    index = 'test'
  end  
  
  tankit index do
  # Index values for search purposes
    indexes :name
    
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
  
end
