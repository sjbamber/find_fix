class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.boolean "post_type", :null => false
      t.integer "parent_id"
      t.string "title"
      t.text "description", :null => false
      t.integer "vote_count"
      t.boolean "post_type", :default => false
      t.references :user
      t.timestamps
    end
  end
end
