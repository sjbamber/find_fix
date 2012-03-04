class CreatePostCategories < ActiveRecord::Migration
  def change
    create_table :post_categories do |t|
      t.references :post
      t.references :category
      t.timestamps
    end
    add_index :post_categories, ['post_id', 'category_id']
  end
end
