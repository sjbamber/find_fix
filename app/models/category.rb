class Category < ActiveRecord::Base

  # include the Tanker module for search using IndexTank
  include Tanker
  
  has_many :post_categories
  has_many :posts, :through => :post_categories
  has_ancestry
  
  validates_presence_of  :name, :message => "At least one category must be selected"
  with_options :allow_blank => true do |v|
    v.validates_length_of :name, { :within => 3..255 }
    v.validates_uniqueness_of :name
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
    indexes :ancestry
    
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
