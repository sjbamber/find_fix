class CreateTagOwnerships < ActiveRecord::Migration
  def change
    create_table :tag_ownerships do |t|
      t.references :user
      t.references :tag
      t.timestamps
    end
    add_index :tag_ownerships, ['user_id', 'tag_id']
  end
end
