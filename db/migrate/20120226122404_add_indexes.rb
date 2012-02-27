# Adds indexes for the problems, solutions and users tables

class AddIndexes < ActiveRecord::Migration
  def up
    add_index("users", "username")
    add_index("problems", "user_id")
    add_index("solutions", "problem_id")
    add_index("solutions", "user_id")  
  end

  def down
    remove_index("solutions", "user_id")
    remove_index("solutions", "problem_id")
    remove_index("problems", "user_id")
    remove_index("users", "username")
  end
end
