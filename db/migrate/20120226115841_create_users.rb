class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string "name", :limit => 60
      t.string "email", :limit => 60, :null => false
      t.string "username", :limit => 40, :null => false, :uniqueness => true
      t.string "hashed_password", :limit => 40, :null => false
      t.string "salt", :limit => 40, :null => false
      t.timestamps
    end
  end
end
