class RemoveSolutionFromPost < ActiveRecord::Migration
  def up
    remove_column :posts, :accepted_solution
    remove_column :posts, :post_type
    remove_column :posts, :parent_id
  end

  def down

    add_column :posts, :parent_id
    add_column :posts, :post_type
    add_column :posts, :accepted_solution
  end
end
