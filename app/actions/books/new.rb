# frozen_string_literal: true

# Hanami port of `BooksController#new` (`@book = Book.new`).
module Bookshelf
  module Actions
    module Books
          # Renders the "new book" form.
          #
          # Passes a `nil` book so the shared form partial renders empty fields,
          # plus the shared `routes` and `notice` helpers.
          #
          # @see Bookshelf::Views::Books::New
          # @api public
      class New < Bookshelf::Action
               # Handles an HTTP GET against `GET /books/new`.
               #
               # @return [void] always renders HTTP 200 with the new-book form
            def handle(request, response)
              response.render(
                Bookshelf::Views::Books::New.new,
                book: nil,
                routes: routes,
                notice: notice(request),
                 )
            end
      end
    end
  end
end
