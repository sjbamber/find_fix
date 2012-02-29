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

ActiveRecord::Schema.define(:version => 20120228211244) do

  create_table "categories", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "parent_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "categories_posts", :id => false, :force => true do |t|
    t.integer "category_id"
    t.integer "post_id"
  end

  add_index "categories_posts", ["category_id", "post_id"], :name => "index_categories_posts_on_category_id_and_post_id"

  create_table "comments", :force => true do |t|
    t.string   "comment",    :null => false
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "comments", ["user_id", "post_id"], :name => "index_comments_on_user_id_and_post_id"

  create_table "error_messages", :force => true do |t|
    t.text     "description", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "error_messages_posts", :id => false, :force => true do |t|
    t.integer "error_message_id"
    t.integer "post_id"
  end

  add_index "error_messages_posts", ["error_message_id", "post_id"], :name => "index_error_messages_posts_on_error_message_id_and_post_id"

  create_table "posts", :force => true do |t|
    t.boolean  "post_type",   :default => false
    t.integer  "parent_id"
    t.string   "title"
    t.text     "description",                    :null => false
    t.integer  "vote_count"
    t.integer  "user_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"

  create_table "posts_tags", :id => false, :force => true do |t|
    t.integer "post_id"
    t.integer "tag_id"
  end

  add_index "posts_tags", ["post_id", "tag_id"], :name => "index_posts_tags_on_post_id_and_tag_id"

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
  end

  add_index "votes", ["user_id", "post_id", "vote_type_id"], :name => "index_votes_on_user_id_and_post_id_and_vote_type_id"

end
