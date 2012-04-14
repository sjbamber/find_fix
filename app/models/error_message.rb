class ErrorMessage < ActiveRecord::Base
  
  has_many :post_error_messages
  has_many :posts, :through => :post_error_messages
  
  validates_presence_of  :description
  with_options :allow_blank => true do |v|
    v.validates_length_of :description, { :within => 3..255 }
  end
  
end
