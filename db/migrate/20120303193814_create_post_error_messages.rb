class CreatePostErrorMessages < ActiveRecord::Migration
  def change
    create_table :post_error_messages do |t|
      t.references :post
      t.references :error_message
      t.timestamps
    end
    add_index :post_error_messages, ['post_id', 'error_message_id']
  end
end
