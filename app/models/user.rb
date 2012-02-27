class User < ActiveRecord::Base
  has_many :problems
  has_many :solutions
  has_and_belongs_to_many :tags
end
