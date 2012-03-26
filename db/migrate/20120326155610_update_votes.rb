class UpdateVotes < ActiveRecord::Migration
  def up
    change_table :votes do |t|
      t.references :solution
      t.references :comment
    end
    add_index :votes, "solution_id"
    add_index :votes, "comment_id"
  end

  def down
    remove_index :votes, "comment_id"
    remove_index :votes, "solution_id"
    remove_column :votes, "comment_id"
    remove_column :votes, "solution_id"
  end
end
