class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer "post_type", :default => 0  # post type 0 for problem 1 for solution
      t.integer "parent_id"
      t.string "title"
      t.text "description", :null => false
      t.integer "vote_count"
      t.boolean "accepted_solution", :default => false
      t.references :user
      t.timestamps
    end
  end
end
