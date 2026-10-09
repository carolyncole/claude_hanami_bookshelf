# frozen_string_literal: true

# Converts the Rails `create_table "books"` (db/schema.rb) into a ROM/Sequel
# migration. The Rails migration had no explicit up/down body; this one
# recreates the `books` table with the same columns.
#
# Rails original (db/schema.rb):
#   create_table "books", force: :cascade do |t|
#     t.string "author"
#     t.datetime "created_at", null: false
#     t.string "title"
#     t.datetime "updated_at", null: false
#   end
ROM::SQL.migration do
  change do
    create_table(:books) do
      primary_key :id

      String "author"
      Time "created_at", null: false
      String "title"
      Time "updated_at", null: false
    end
  end
end
