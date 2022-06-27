# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_05_21_150214) do
  create_table "game_questions", force: :cascade do |t|
    t.integer "game_id"
    t.integer "question_id", null: false
    t.integer "a"
    t.integer "b"
    t.integer "c"
    t.integer "d"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "help_hash"
    t.index ["game_id"], name: "index_game_questions_on_game_id"
    t.index ["question_id"], name: "index_game_questions_on_question_id"
  end

  create_table "games", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "finished_at"
    t.integer "current_level", default: 0, null: false
    t.boolean "is_failed"
    t.integer "prize", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "fifty_fifty_used", default: false, null: false
    t.boolean "audience_help_used", default: false, null: false
    t.boolean "friend_call_used", default: false, null: false
    t.index ["user_id"], name: "index_games_on_user_id"
  end

  create_table "questions", force: :cascade do |t|
    t.integer "level", null: false
    t.text "text", null: false
    t.string "answer1", null: false
    t.string "answer2"
    t.string "answer3"
    t.string "answer4"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["level"], name: "index_questions_on_level"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", default: "", null: false
    t.boolean "is_admin", default: false, null: false
    t.integer "balance", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "game_questions", "games"
  add_foreign_key "game_questions", "questions"
  add_foreign_key "games", "users"
end
