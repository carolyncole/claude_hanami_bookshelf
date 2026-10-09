# frozen_string_literal: true

module Bookshelf
  module Views
    module Books
        # Renders `GET /books/:id/edit`.
        #
        # Rails original: `app/views/books/edit.html.erb`, fed by
        # `BooksController#edit` (the `@book` set by `before_action :set_book`).
        #
        # In Hanami the loaded `book` (a `{Bookshelf::Structs::Book}`) and
        # `routes` (for the form action and the "Show"/"Back" links) are exposed
        # here.
        #
        # @see app/templates/books/edit.html.erb
        #
        # @api public
      class Edit < View
        config.template = "books/edit"

        expose :book
        expose :routes
        expose :notice, default: nil
      end
    end
  end
end
