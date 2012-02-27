class CreateErrorMessages < ActiveRecord::Migration
  def change
    create_table :error_messages do |t|
      t.text "description", :null => false
      t.timestamps
    end
  end
end
