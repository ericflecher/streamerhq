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

ActiveRecord::Schema.define(:version => 20130228025421) do

  create_table "comments", :force => true do |t|
    t.integer   "commentable_id",   :default => 0
    t.string    "commentable_type", :default => ""
    t.string    "title",            :default => ""
    t.text      "body",             :default => ""
    t.string    "subject",          :default => ""
    t.integer   "user_id",          :default => 0,  :null => false
    t.integer   "parent_id"
    t.integer   "lft"
    t.integer   "rgt"
    t.timestamp "created_at",                       :null => false
    t.timestamp "updated_at",                       :null => false
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "custom_asses", :force => true do |t|
    t.integer   "user_id"
    t.integer   "feature_id"
    t.integer   "doc_id"
    t.text      "codetype"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
  end

  create_table "docs", :force => true do |t|
    t.string    "title"
    t.text      "description"
    t.timestamp "created_at",         :null => false
    t.timestamp "updated_at",         :null => false
    t.string    "photo_file_name"
    t.string    "photo_content_type"
    t.integer   "photo_file_size"
    t.timestamp "photo_updated_at"
    t.integer   "pdoc"
    t.integer   "arch"
  end

  create_table "features", :force => true do |t|
    t.string    "title"
    t.text      "gherkin"
    t.timestamp "created_at",         :null => false
    t.timestamp "updated_at",         :null => false
    t.string    "photo_file_name"
    t.string    "photo_content_type"
    t.integer   "photo_file_size"
    t.timestamp "photo_updated_at"
  end

  create_table "featurevers", :force => true do |t|
    t.string    "title"
    t.text      "gherkin"
    t.string    "photo_file_name"
    t.string    "photo_content_type"
    t.integer   "photo_file_size"
    t.timestamp "photo_updated_at"
    t.timestamp "created_at",         :null => false
    t.timestamp "updated_at",         :null => false
    t.integer   "featureid"
  end

  create_table "feeds", :force => true do |t|
    t.integer  "doc_id"
    t.integer  "feature_id"
    t.integer  "user_id"
    t.text     "message"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "featurever_id"
    t.text     "feedtype"
  end

  create_table "follows", :force => true do |t|
    t.integer   "followable_id",                      :null => false
    t.string    "followable_type",                    :null => false
    t.integer   "follower_id",                        :null => false
    t.string    "follower_type",                      :null => false
    t.boolean   "blocked",         :default => false, :null => false
    t.timestamp "created_at",                         :null => false
    t.timestamp "updated_at",                         :null => false
  end

  add_index "follows", ["followable_id", "followable_type"], :name => "fk_followables"
  add_index "follows", ["follower_id", "follower_type"], :name => "fk_follows"

  create_table "roles", :force => true do |t|
    t.string    "name"
    t.integer   "resource_id"
    t.string    "resource_type"
    t.timestamp "created_at",    :null => false
    t.timestamp "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "taggings", :force => true do |t|
    t.integer   "tag_id"
    t.integer   "taggable_id"
    t.string    "taggable_type"
    t.integer   "tagger_id"
    t.string    "tagger_type"
    t.string    "context",       :limit => 128
    t.timestamp "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string    "email",                                :default => "", :null => false
    t.string    "encrypted_password",                   :default => ""
    t.string    "reset_password_token"
    t.timestamp "reset_password_sent_at"
    t.timestamp "remember_created_at"
    t.integer   "sign_in_count",                        :default => 0
    t.timestamp "current_sign_in_at"
    t.timestamp "last_sign_in_at"
    t.string    "current_sign_in_ip"
    t.string    "last_sign_in_ip"
    t.timestamp "created_at",                                           :null => false
    t.timestamp "updated_at",                                           :null => false
    t.string    "name"
    t.string    "invitation_token",       :limit => 60
    t.timestamp "invitation_sent_at"
    t.timestamp "invitation_accepted_at"
    t.integer   "invitation_limit"
    t.integer   "invited_by_id"
    t.string    "invited_by_type"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token"
  add_index "users", ["invited_by_id"], :name => "index_users_on_invited_by_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

  create_table "votes", :force => true do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], :name => "index_votes_on_votable_id_and_votable_type_and_vote_scope"
  add_index "votes", ["votable_id", "votable_type"], :name => "index_votes_on_votable_id_and_votable_type"
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], :name => "index_votes_on_voter_id_and_voter_type_and_vote_scope"
  add_index "votes", ["voter_id", "voter_type"], :name => "index_votes_on_voter_id_and_voter_type"

end
