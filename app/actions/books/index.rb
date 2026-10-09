# frozen_string_literal: true

# Hanami port of `BooksController#index` (`@books = Book.all`).
module Bookshelf
  module Actions
    module Books
         # Lists every book and renders the {Bookshelf::Views::Books::Index} view.
         #
         # @see Bookshelf::Views::Books::Index
         # @api public
      class Index < Bookshelf::Action
              # Handles an HTTP GET against `GET /books`.
              #
              # Loads every book through the repository and renders the index
              # view, exposing the collection plus the shared `routes` and
              # `notice` helpers.
              #
              # @return [void] always renders HTTP 200 with the index page
            def handle(request, response)
              books = books_repo.all

              response.render(
                Bookshelf::Views::Books::Index.new,
                books: books,
                routes: routes,
                notice: notice(request),
                 )
            end
      end
    end
  end
end
