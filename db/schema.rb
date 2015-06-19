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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150408154009) do

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "authorizations", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.string   "token"
    t.string   "secret"
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authorizations", ["user_id"], name: "index_authorizations_on_user_id", using: :btree

  create_table "ckeditor_assets", force: true do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "components", force: true do |t|
    t.decimal  "count",                 precision: 50, scale: 3
    t.integer  "food_id"
    t.integer  "recipe_id"
    t.string   "count_type", limit: 10
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "components", ["food_id"], name: "index_components_on_food_id", using: :btree
  add_index "components", ["recipe_id"], name: "index_components_on_recipe_id", using: :btree

  create_table "favourite_recipes", force: true do |t|
    t.integer  "recipe_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favourite_recipes", ["recipe_id"], name: "index_favourite_recipes_on_recipe_id", using: :btree
  add_index "favourite_recipes", ["user_id"], name: "index_favourite_recipes_on_user_id", using: :btree

  create_table "food_categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "food_prices", force: true do |t|
    t.decimal  "price",                 precision: 10, scale: 4
    t.integer  "food_id"
    t.integer  "user_id"
    t.string   "count_type", limit: 10
    t.string   "currency",   limit: 3
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "food_prices", ["food_id"], name: "index_food_prices_on_food_id", using: :btree

  create_table "food_values", force: true do |t|
    t.decimal "energy",             precision: 20, scale: 4
    t.decimal "protein",            precision: 20, scale: 4
    t.decimal "fat",                precision: 20, scale: 4
    t.decimal "sugar",              precision: 20, scale: 4
    t.decimal "sugar_index",        precision: 20, scale: 4
    t.integer "nutritionable_id"
    t.string  "nutritionable_type"
  end

  create_table "food_weights", force: true do |t|
    t.decimal  "kg",                         precision: 20, scale: 4
    t.string   "count_type",      limit: 10
    t.integer  "weightable_id"
    t.string   "weightable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "foods", force: true do |t|
    t.string   "name"
    t.string   "image"
    t.string   "slug"
    t.integer  "food_price_id"
    t.integer  "user_id"
    t.integer  "food_category_id"
    t.boolean  "is_moderated"
    t.integer  "count_type_preset"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "meta_pages", force: true do |t|
    t.string   "path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "meta_tags", force: true do |t|
    t.string   "key"
    t.text     "text"
    t.boolean  "no_wrap_title"
    t.string   "value"
    t.integer  "meta_tags_able_id"
    t.string   "meta_tags_able_type"
    t.integer  "storage_width"
    t.integer  "storage_height"
    t.integer  "storage_depth"
    t.string   "storage_format"
    t.string   "storage_mime_type"
    t.string   "storage_size"
    t.float    "storage_aspect_ratio", limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "partials", force: true do |t|
    t.string "placement"
    t.text   "text"
  end

  add_index "partials", ["placement"], name: "index_partials_on_placement", unique: true, using: :btree

  create_table "recipe_tags", force: true do |t|
    t.string   "name"
    t.string   "image"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recipe_text_nodes", force: true do |t|
    t.string   "image"
    t.string   "node",       limit: 10
    t.text     "text"
    t.integer  "recipe_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recipe_to_tag", force: true do |t|
    t.integer "recipe_tag_id"
    t.integer "recipe_id"
  end

  create_table "recipes", force: true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "text"
    t.string   "image"
    t.integer  "views_count",                          default: 1
    t.integer  "duration"
    t.decimal  "kg",          precision: 20, scale: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "static_pages", force: true do |t|
    t.string   "slug"
    t.string   "title"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                            default: "", null: false
    t.string   "encrypted_password",               default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                    default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "fname"
    t.string   "lname"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "currency",               limit: 3
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "watched_recipes", force: true do |t|
    t.integer  "recipe_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "watched_recipes", ["recipe_id"], name: "index_watched_recipes_on_recipe_id", using: :btree
  add_index "watched_recipes", ["user_id"], name: "index_watched_recipes_on_user_id", using: :btree

end
