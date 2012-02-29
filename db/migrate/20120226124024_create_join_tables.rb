# Creates join tables needed for the following m:n relationships
# post - category
# post - tag
# post - error message
# user - tag

class CreateJoinTables < ActiveRecord::Migration
  
  def up
    
    create_table :categories_posts, :id =>false do |t|
      t.references :category
      t.references :post
    end
    add_index :categories_posts, ["category_id", "post_id"]
    
    create_table :posts_tags, :id =>false do |t|
      t.references :post
      t.references :tag
    end
    add_index :posts_tags, ["post_id", "tag_id"]
    
    create_table :error_messages_posts, :id =>false do |t|   
      t.references :error_message
      t.references :post
    end
    add_index :error_messages_posts, ["error_message_id", "post_id"]
    
    create_table :tags_users, :id =>false do |t|
      t.references :tag
      t.references :user
    end
    add_index :tags_users, ["tag_id", "user_id"]
    
  end

  def down
    
    drop_table :tags_users
    drop_table :error_messages_posts
    drop_table :posts_tags
    drop_table :categories_posts
    
  end
  
end
