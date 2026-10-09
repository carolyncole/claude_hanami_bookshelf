# frozen_string_literal: true

# Database setup for the RSpec suite. See spec/spec_helper.rb.
#
# This is intentionally *not* autoloaded (it lives under spec/support, outside
# the app/ and lib/ Zeitwerk roots), so it requires "hanami/boot" at its own
# convenience rather than fighting the app's eager constant resolution.
require "sqlite3"

module TestDatabase
   # The separate test database; matches hanami-db's HANAMI_ENV=test transform
  # of DATABASE_URL (db/bookshelf.sqlite -> db/bookshelf_test.sqlite).
  DB_FILE = File.expand_path("../../db/bookshelf_test.sqlite", __dir__)

   # Load config/db/structure.sql into a brand-new test database so the app can
  # boot with its `infer: true` relation. Idempotent: the file is recreated each
  # time.
  def self.prepare!(project_root)
    File.delete(DB_FILE) if File.exist?(DB_FILE)

    structure = File.join(project_root, "config", "db", "structure.sql")
    unless File.exist?(structure)
      raise "Missing #{structure} -- run `bundle exec hanami db prepare` first."
    end

    db = SQLite3::Database.new(DB_FILE)
    db.execute_batch(File.read(structure))
    db.close
  end

   # Delete every row except the migration bookkeeping. SQLite uses a single
  # shared connection, so a plain truncation is a correct, dependency-free
  # replacement for DatabaseCleaner.
  def self.truncate
    connection = Hanami.app["db.rom"].gateways[:default].connection

    connection.tables.each do |table|
      next if table == "schema_migrations"

      connection.run("DELETE FROM #{table}")
    end
  end
end
