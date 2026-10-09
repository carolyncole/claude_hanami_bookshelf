# frozen_string_literal: true

module Bookshelf
  module Views
    module Books
       # Renders `GET /books`.
       #
       # Rails original: `app/views/books/index.html.erb`, fed by
       # `BooksController#index`'s `@books = Book.all`.
       #
       # In Hanami the list is the `Route`'s job to supply; this view only
       # declares which locals the template may read:
       #
       #   - `books` -- the `{Bookshelf::Structs::Book}` list
       #   - `routes` -- the URL helper, used for the "Show"/"New book" links
       #   - `notice` -- the green flash banner (may be nil)
       #
       # @see app/templates/books/index.html.erb
       #
       # @api public
      class Index < View
        config.template = "books/index"

        expose :books
        expose :routes
        expose :notice
      end
    end
  end
end
