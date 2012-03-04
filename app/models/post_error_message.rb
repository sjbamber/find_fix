class PostErrorMessage < ActiveRecord::Base
  belongs_to :post
  belongs_to :error_message
end
