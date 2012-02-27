class CreateSolutions < ActiveRecord::Migration
  def change
    create_table :solutions do |t|
      t.text "summary", :null => false
      t.integer "score"
      t.references :problem
      t.references :user
      t.timestamps
    end
  end
end
