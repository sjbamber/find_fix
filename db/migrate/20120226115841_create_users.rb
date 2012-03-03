class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string "name", :limit => 60
      t.string "email", :limit => 100, :null => false, :uniqueness => true
      t.string "username", :limit => 25, :null => false, :uniqueness => true
      t.string "hashed_password", :limit => 40, :null => false
      t.string "salt", :limit => 40, :null => false
      t.integer "role", :default => 1, :null => false # User role: 1 = Standard User, 2 = Admin User
      t.timestamps
    end
  end
end
