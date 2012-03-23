require 'test_helper'

class SolutionTest < ActiveSupport::TestCase
# Load Test data
fixtures :posts, :tags, :categories
  # setup objects for tests
  def setup
    @solution = Solution.new
  end

  # Test Validation Works
  test "solution attributes are not empty" do
    assert @solution.invalid?
    assert @solution.errors[:description].any?, "Solution description must be present"
  end
  
end
