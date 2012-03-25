class UpdateComments < ActiveRecord::Migration
  def up
    change_table :comments do |t|
      t.references :solution
    end
    add_index :comments, "solution_id"
  end

  def down
    remove_index :comments, "solution_id"
    remove_column :comments, "solution_id"
  end
end
