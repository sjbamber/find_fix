class CreateProblems < ActiveRecord::Migration
  def change
    create_table :problems do |t|
      t.string "title", :null => false
      t.text "description", :null => false
      t.integer "score"
      t.references :user
      t.timestamps
    end
  end
end
