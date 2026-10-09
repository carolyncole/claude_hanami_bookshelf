# frozen_string_literal: true

# Run the whole suite against the `*_test` database. hanami-db rewrites
# DATABASE_URL to `db/bookshelf_test.sqlite` whenever HANAMI_ENV is "test".
ENV["HANAMI_ENV"] ||= "test"
require "sqlite3"

# --- Prepare the test database, then boot the app ------------------------
#
# Booting the app finalises every relation with `schema …, infer: true`, which
# reads the column set straight from the database -- so `db/bookshelf_test.sqlite`
# must already hold the `books` table, or `require "hanami/boot"` raises "table
# books probably doesn't exist". We therefore load the checked-in
# `config/db/structure.sql` into a fresh test database, and only then boot the
# app (which also defines the `Bookshelf` constants the specs reference).
require_relative "support/test_database"

TestDatabase.prepare!(File.expand_path("..", __dir__))
require "hanami/boot"

# System-spec (Capybara) support -- loaded after the app is booted so that
# `Capybara.app` can point at the live `Hanami.app` rack application.
require_relative "support/capybara"
require_relative "support/actions"
require_relative "support/books"

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :expect }
  config.mock_with(:rspec)

      # Every action spec can call `request(...)` to drive `Hanami.app`.
  config.include ActionResponse

     # A `type: :db` example group also gets `db: true` so the per-example
     # cleanup hook below can opt in.
  config.define_derived_metadata(type: :db) do |metadata|
    metadata[:db] = true
  end

      # The Capybara system specs also touch the `books` table, so they get the
      # same per-example truncation.
  config.define_derived_metadata(type: :system) do |metadata|
    metadata[:db] = true
  end

     # Truncate the books table after each database-backed example.
  config.around(:each, :db) do |example|
    example.run

    TestDatabase.truncate
  end
end
