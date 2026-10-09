# frozen_string_literal: true

module Bookshelf
  module Relations
     # The ROM relation for the `books` table.
     #
     # In Rails this is `class Book < ApplicationRecord`; here the ORM split keeps
     # the schema declaration in one place and pushes the behaviour elsewhere:
     # queries/CRUD live in {Bookshelf::Repos::BookRepo}, and the record shape
     # (attribute types, instance methods) lives in {Bookshelf::Structs::Book}.
     #
     # `infer: true` means the column set is read straight from the database
     # after the migration runs, so no per-attribute schema has to be repeated.
     #
     # @example reading the table
     #   rom = Hanami.app["db.rom"]
     #   rom.relations[:books].to_a
     #
     # @api public
    class Book < Bookshelf::DB::Relation
      schema :books, infer: true
    end
  end
end
