class CreatePostTags < ActiveRecord::Migration
  def change
    create_table :post_tags do |t|
      t.references :post
      t.references :tag
      t.timestamps
    end
    add_index :post_tags, ['post_id', 'tag_id']
  end
end
