require 'test_helper'

class VoteTypeTest < ActiveSupport::TestCase
# Load Test data
fixtures :vote_types
  # setup objects for tests
  def setup
    @vote_type = VoteType.new
  end

# Test Validation Works
  test "vote type name must not be empty" do
    assert @vote_type.invalid?
    assert @vote_type.errors[:name].any?, "VoteType name must be present"
  end

  test "vote type name is a maximum of 30 characters" do
    @vote_type.name = "a"*31
    assert @vote_type.invalid?, "VoteType name over 30 characters should not be valid"

    @vote_type.name = "a"*30
    assert @vote_type.valid?, "VoteType name less than 30 characters should be valid"  
  end
  
end
