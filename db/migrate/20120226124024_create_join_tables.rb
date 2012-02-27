# Creates join tables needed for the following m:n relationships
# problem - category
# problem - tag
# problem - error message
# user - tag

class CreateJoinTables < ActiveRecord::Migration
  
  def up
    
    create_table :categories_problems, :id =>false do |t|
      t.references :category
      t.references :problem
    end
    add_index :categories_problems, ["category_id", "problem_id"]
    
    create_table :problems_tags, :id =>false do |t|
      t.references :problem
      t.references :tag
    end
    add_index :problems_tags, ["problem_id", "tag_id"]
    
    create_table :error_messages_problems, :id =>false do |t|   
      t.references :error_message
      t.references :problem
    end
    add_index :error_messages_problems, ["error_message_id", "problem_id"]
    
    create_table :tags_users, :id =>false do |t|
      t.references :tag
      t.references :user
    end
    add_index :tags_users, ["tag_id", "user_id"]
    
  end

  def down
    
    drop_table :tags_users
    drop_table :error_messages_problems
    drop_table :problems_tags
    drop_table :categories_problems
    
  end
  
end
