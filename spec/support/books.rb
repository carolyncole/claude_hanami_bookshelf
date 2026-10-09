# frozen_string_literal: true

# Helpers for the system specs -- the Hanami replacement for the ActiveRecord
# `Book.create`/`Book.last`/`Book.count` calls that the original Rails specs
# made straight against the model.
#
# In Hanami the model layer is query-backed, so data mutation goes through
# {Bookshelf::Repos::BookRepo}. Each call returns a `Dry::Monads::Result`, so
# we unwrap the `Success` and let a `Failure` propagate (which would surface as a
# test error -- i.e. the repo's job is to succeed in the happy path of seeding).
module BookFactory
  include Dry::Monads[:result]

  # A single shared repo for the example.
  #
  # @return [Bookshelf::Repos::BookRepo]
  def repo
    @repo ||= Bookshelf::Repos::BookRepo.new
  end

  # Seed a book. The Hanami equivalent of `Book.create(title:, author:)`.
  #
  # @param title [String]
  # @param author [String]
  # @return [Bookshelf::Structs::Book]
  def create_book(title:, author:)
    case repo.create(title:, author:)
    in Success(book)
      book
    else
      raise
    end
  end

  # The most recently created book. The Hanami equivalent of `Book.last`.
  #
  # @return [Bookshelf::Structs::Book, nil]
  def last_book
    repo.all.last
  end

  # The current row count. The Hanami equivalent of `Book.count`.
  #
  # @return [Integer]
  def book_count
    repo.all.size
  end

   # Re-fetch a book by id. The Hanami equivalent of `book.reload` -- a ROM
   # struct is immutable, so "reloading" means re-reading it from the repo.
   #
   # @param id [Integer]
   # @return [Bookshelf::Structs::Book, nil]
  def get_book(id:)
    case repo.get(id:)
    in Success(book)
      book
    else
      nil
    end
  end
end

RSpec.configure do |config|
  config.include BookFactory, type: :system
end
