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

ActiveRecord::Schema.define(version: 20151022032722) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.boolean  "purchased"
    t.float    "viewTime"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "productName"
    t.string   "price"
    t.text     "imageurl"
    t.string   "externalid"
    t.string   "detailPageUrl"
    t.integer  "supplier_id"
  end

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "category_name"
    t.integer  "category_id"
    t.integer  "parent_id"
    t.integer  "child_id"
  end

  create_table "category_relations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "parent_id"
    t.integer  "child_id"
  end

  create_table "friendships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "productqueues", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "productids", default: [],              array: true
    t.string   "tag"
  end

  create_table "products", force: :cascade do |t|
    t.string   "productName"
    t.integer  "user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "supplier_id"
    t.string   "price"
    t.text     "imageurl"
    t.string   "externalId"
    t.string   "detailPageUrl"
    t.string   "tag"
  end

  create_table "suppliers", force: :cascade do |t|
    t.string   "supplierName"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "temp_products", id: false, force: :cascade do |t|
    t.text "asin"
  end

  create_table "users", force: :cascade do |t|
    t.string   "firstName"
    t.string   "lastName"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
