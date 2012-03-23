class CreateSolutions < ActiveRecord::Migration
  def change
    create_table :solutions do |t|
      t.text "description", :null => false
      t.references :user
      t.references :post
      t.timestamps
    end
    add_index :solutions, ['user_id', 'post_id']
  end
end
