# frozen_string_literal: true

module Bookshelf
  module Repos
       # Queries and CRUD for the `books` table -- the Hanami/ROM replacement for
       # `class Book < ApplicationRecord`.
       #
       # Reads and writes both go through the inferred relation (#root, i.e.
       # `rom.relations[:books]`): queries use the relation reader, and writes use
       # the reader's command-backed `insert`, `update` and `delete` methods.
       #
       # Every mutating read returns a `Dry::Monads::Result` so callers can
       # pattern-match on success/failure instead of rescuing
       # `ActiveRecord::RecordNotFound`-style exceptions:
       #
       #   case repo.get(id: 1)
       #   in Success(book)
       #     book.title
       #   in Failure(Bookshelf::Repos::BookRepo::BookNotFound)
       #      "not found"
       #   end
       #
       # Timestamps are set by hand: ROM has no save callbacks, so #create and
       # #update are the stand-ins for ActiveRecord's `created_at`/`updated_at`
       # auto-assignment.
       #
       # @api public
    class BookRepo < Bookshelf::DB::Repo
      include Dry::Monads[:result]

         # Raised, wrapped in a `Dry::Monads::Result::Failure`, when a get/update
         # cannot find the requested row. The Hanami equivalent of
         # `ActiveRecord::RecordNotFound`.
         #
         # @api public
      class BookNotFound < StandardError
             # @return [Integer] the id that was not found
        attr_reader :id

             # @param id [Integer] the missing book's id
             # @return [BookNotFound]
        def initialize(id:)
          super("Book not found: #{id}")
            @id = id
        end
      end

         # Returns every book.
         #
         # The Rails equivalent of `Book.all`.
         #
         # @return [Array<Bookshelf::Structs::Book>]
      def all
        root.to_a
      end

         # Finds one book by id.
         #
         # The Rails equivalent of `Book.find(params.expect(:id))`, but instead
         # of raising it returns a failure you can pattern-match.
         #
         # @param id [Integer] the book's primary key
         # @return [Dry::Monads::Result]
         #   `Success(Bookshelf::Structs::Book)` when found, otherwise
         #   `Failure(BookNotFound)`.
         # @see BookNotFound
      def get(id:)
        case (record = root.where(id: id).one)
        when nil
          Failure(BookNotFound.new(id: id))
        else
          Success(Structs::Book.new(record))
        end
      end

         # Inserts a new book and returns it.
         #
         # The Rails equivalent of `Book.new(book_params).save`. `insert` returns
         # the new row's id directly (SQLite `last_insert_rowid`), which is then
         # re-fetched so the returned struct carries all columns.
         #
         # @param title [String] the book's title
         # @param author [String] the book's author
         # @return [Dry::Monads::Result]
         #   `Success(Bookshelf::Structs::Book)` for the inserted row.
      def create(title:, author:)
        now = Time.now
        id = root.insert(
          title: title,
          author: author,
          created_at: now,
          updated_at: now,
          )
        get(id: id)
      end

         # Updates the title/author of an existing book and bumps `updated_at`.
         #
         # The Rails equivalent of `book.update(book_params)`. If no row matches
         # the id, the row is not created -- the subsequent `get` yields a
         # `Failure(BookNotFound)`.
         #
         # @param id [Integer] the book's primary key
         # @param title [String] the new title
         # @param author [String] the new author
         # @return [Dry::Monads::Result]
         #   `Success(Bookshelf::Structs::Book)` when the row was found,
         #   otherwise `Failure(BookNotFound)`.
      def update(id:, title:, author:)
        root.where(id: id).update(
          title: title,
          author: author,
          updated_at: Time.now,
          )
        get(id: id)
      end

         # Deletes a book by id.
         #
         # The Rails equivalent of `book.destroy!`.
         #
         # @param id [Integer] the book's primary key
         # @return [Dry::Monads::Result] `Success(Integer)` holding the deleted id.
      def delete(id:)
        root.where(id: id).delete
        Success(id)
      end
    end
  end
end
