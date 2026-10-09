# frozen_string_literal: true

module Bookshelf
  module Structs
     # Immutable value object for a `books` row.
     #
     # In Rails this is the "smart" half of `class Book < ApplicationRecord`
     # (instance methods, validations, typed attributes). In Hanami/ROM a
     # struct is a frozen record produced from a ROM record:
     #
     #   Book.new(id: 1, title: "T", author: "A",
     #            created_at: Time.now, updated_at: Time.now)
     #
     # {Bookshelf::Repos::BookRepo} builds these; the struct owns no persistence
     # logic. Add domain methods (formatting, validation, etc.) here.
     #
     # Types are read from the shared {Bookshelf::Types} registry (strict).
     # `author`/`title` are nullable in the schema (`t.string`, no
     # `null: false`), so they are `.optional`.
     #
     # @api public
    class Book < Bookshelf::DB::Struct
      attribute :id, Types::Integer
      attribute :title, Types::String.optional
      attribute :author, Types::String.optional
      attribute :created_at, Types::Time
      attribute :updated_at, Types::Time
    end
  end
end
