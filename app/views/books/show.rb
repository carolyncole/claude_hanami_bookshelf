# frozen_string_literal: true

module Bookshelf
  module Views
    module Books
       # Renders `GET /books/:id`.
       #
       # Rails original: `app/views/books/show.html.erb`, fed by
       # `BooksController#show`'s `@book` (loaded by the
       # `before_action :set_book`).
       #
       # In Hanami the single `book` (a `{Bookshelf::Structs::Book}`) is loaded
       # by the Show action via `{Bookshelf::Repos::BookRepo#get}` and exposed
       # here, alongside `routes` (for the Edit/Back/Destroy links) and `notice`
       # (the green flash banner).
       #
       # @see app/templates/books/show.html.erb
       #
       # @api public
      class Show < View
        config.template = "books/show"

        expose :book
        expose :routes
        expose :notice
      end
    end
  end
end
