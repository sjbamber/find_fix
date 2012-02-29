class AddIndexes < ActiveRecord::Migration
  def up
    add_index("users", "username")
    add_index("posts", "user_id")
    add_index :comments, ["user_id", "post_id"]
    add_index :votes, ["user_id", "post_id", "vote_type_id"]
  end

  def down
    remove_index :votes, ["user_id", "post_id", "vote_type_id"]
    remove_index :comments, ["user_id", "post_id"]
    remove_index("posts", "user_id")
    remove_index("users", "username")
  end
end