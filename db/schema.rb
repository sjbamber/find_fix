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

ActiveRecord::Schema.define(:version => 20120326155610) do

  create_table "categories", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "ancestry"
  end

  add_index "categories", ["ancestry"], :name => "index_categories_on_ancestry"

  create_table "comments", :force => true do |t|
    t.string   "comment",     :null => false
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "solution_id"
  end

  add_index "comments", ["solution_id"], :name => "index_comments_on_solution_id"
  add_index "comments", ["user_id", "post_id"], :name => "index_comments_on_user_id_and_post_id"

  create_table "error_messages", :force => true do |t|
    t.text     "description", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "post_categories", :force => true do |t|
    t.integer  "post_id"
    t.integer  "category_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "post_categories", ["post_id", "category_id"], :name => "index_post_categories_on_post_id_and_category_id"

  create_table "post_error_messages", :force => true do |t|
    t.integer  "post_id"
    t.integer  "error_message_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "post_error_messages", ["post_id", "error_message_id"], :name => "index_post_error_messages_on_post_id_and_error_message_id"

  create_table "post_tags", :force => true do |t|
    t.integer  "post_id"
    t.integer  "tag_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "post_tags", ["post_id", "tag_id"], :name => "index_post_tags_on_post_id_and_tag_id"

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "description", :null => false
    t.integer  "vote_count"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"

  create_table "solutions", :force => true do |t|
    t.text     "description", :null => false
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "solutions", ["user_id", "post_id"], :name => "index_solutions_on_user_id_and_post_id"

  create_table "tag_ownerships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "tag_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "tag_ownerships", ["user_id", "tag_id"], :name => "index_tag_ownerships_on_user_id_and_tag_id"

  create_table "tags", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name",            :limit => 60
    t.string   "email",           :limit => 100,                :null => false
    t.string   "username",        :limit => 25,                 :null => false
    t.string   "hashed_password", :limit => 40,                 :null => false
    t.string   "salt",            :limit => 40,                 :null => false
    t.integer  "role",                           :default => 1, :null => false
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

  add_index "users", ["username"], :name => "index_users_on_username"

  create_table "vote_types", :force => true do |t|
    t.string   "name",       :limit => 30
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "votes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.integer  "vote_type_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "solution_id"
    t.integer  "comment_id"
  end

  add_index "votes", ["comment_id"], :name => "index_votes_on_comment_id"
  add_index "votes", ["solution_id"], :name => "index_votes_on_solution_id"
  add_index "votes", ["user_id", "post_id", "vote_type_id"], :name => "index_votes_on_user_id_and_post_id_and_vote_type_id"

end
