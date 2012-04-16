require 'test_helper'

class UserTest < ActiveSupport::TestCase
# Load Test Data
fixtures :users

# Test Validation Works
  test "user attributes must not be empty on create" do
    # Test required field validation
    user = User.new
    assert user.invalid?
    assert user.errors[:email].any?, "Email must be present"
    assert user.errors[:username].any?, "Username must be present"
    assert user.errors[:password].any?, "A Password must be present"
  end
  
  def new_user(email)
    user = User.new(email:  email,
                    username: "exampleuser",
                    password: "examplepassword")
  end  

  test "name validations" do
    user = new_user("abc@example.com")
    # Test Maximum Length of 60 validation
    user.name = "a"*61
    assert user.invalid?, "User Name over 60 characters should not be valid"

    user.name = "a"*60
    assert user.valid?, "User Name of 60 characters and under should be valid" 
  end
  
  test "username validations" do
    user = new_user("abcd@example.com")
    # Test username between 6 and 25 characters validation
    user.username = "a"*26
    assert user.invalid?, "Username over 25 characters should not be valid"
    user.username = "a"*5
    assert user.invalid?, "Username under 6 characters should not be valid"   
    user.username = "a"*25
    assert user.valid?, "Username between 6 and 25 characters should be valid"     
    user.username = "a"*6
    assert user.valid?, "Username between 6 and 25 characters should be valid" 
    # Test username uniqueness validation
    user.username = "testuser" # This user exists in the test database
    assert user.invalid?, "Username should be unique"
  end  
  
  test "email validations" do
    user = new_user("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa@bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb.com") #101 characters
    assert user.invalid?, "Email over 100 characters should not be valid" 
    user.email = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa@bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb.com" #100 characters
    assert user.valid?, "Email of 100 characters and under should be valid"
    
    # test regex format validation for allowed email addresses
    allowed = %w{ abcdef@example.com Abcdef@eXample.co.uk }
    # test regex format validation for disallowed email addresses
    # test email is unique validation - testuser@mail.com is an existing email in the test database
    disallowed = %w{ abcdef@example abcdef abc@examplecom _abcd@ abcd@example. testuser@mail.com }
    allowed.each do |email|
      assert new_user(email).valid?, "#{email} should not be invalid"
    end    
    disallowed.each do |email|
      assert new_user(email).invalid?, "#{email} should not be valid"
    end
  end

  test "password validations" do
    user = new_user("abcd@example.com")
    # Test password between 8 and 25 characters validation
    user.password = "a"*26
    assert user.invalid?, "Password over 25 characters should not be valid"
    user.password = "a"*7
    assert user.invalid?, "Password under 8 characters should not be valid"   
    user.password = "a"*25
    assert user.valid?, "Password between 8 and 25 characters should be valid"     
    user.password = "a"*8
    assert user.valid?, "Password between 8 and 25 characters should be valid" 
  end  
  
end
