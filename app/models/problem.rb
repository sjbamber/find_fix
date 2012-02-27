class Problem < ActiveRecord::Base
  
  belongs_to :user
  has_many :solutions
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :error_messages
  
end
