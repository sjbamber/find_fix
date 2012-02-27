# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120226124218) do

  create_table "categories", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "parent_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "categories_problems", :id => false, :force => true do |t|
    t.integer "category_id"
    t.integer "problem_id"
  end

  add_index "categories_problems", ["category_id", "problem_id"], :name => "index_categories_problems_on_category_id_and_problem_id"

  create_table "error_messages", :force => true do |t|
    t.text     "description", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "error_messages_problems", :id => false, :force => true do |t|
    t.integer "error_message_id"
    t.integer "problem_id"
  end

  add_index "error_messages_problems", ["error_message_id", "problem_id"], :name => "index_error_messages_problems_on_error_message_id_and_problem_id"

  create_table "problems", :force => true do |t|
    t.string   "title",       :null => false
    t.text     "description", :null => false
    t.integer  "score"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "problems", ["user_id"], :name => "index_problems_on_user_id"

  create_table "problems_tags", :id => false, :force => true do |t|
    t.integer "problem_id"
    t.integer "tag_id"
  end

  add_index "problems_tags", ["problem_id", "tag_id"], :name => "index_problems_tags_on_problem_id_and_tag_id"

  create_table "solutions", :force => true do |t|
    t.text     "summary",    :null => false
    t.integer  "score"
    t.integer  "problem_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "solutions", ["problem_id"], :name => "index_solutions_on_problem_id"
  add_index "solutions", ["user_id"], :name => "index_solutions_on_user_id"

  create_table "tags", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tags_users", :id => false, :force => true do |t|
    t.integer "tag_id"
    t.integer "user_id"
  end

  add_index "tags_users", ["tag_id", "user_id"], :name => "index_tags_users_on_tag_id_and_user_id"

  create_table "users", :force => true do |t|
    t.string   "name",            :limit => 60
    t.string   "email",           :limit => 60, :null => false
    t.string   "username",        :limit => 40, :null => false
    t.string   "hashed_password", :limit => 40, :null => false
    t.string   "salt",            :limit => 40, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "users", ["username"], :name => "index_users_on_username"

end
