# frozen_string_literal: true

module Bookshelf
  module Views
    module Books
        # Renders `GET /books/new`.
        #
        # Rails original: `app/views/books/new.html.erb`, fed by
        # `BooksController#new`'s `@book = Book.new`.
        #
        # In Hanami a fresh record has no struct yet, so `book` is exposed but
        # may be `nil` (the template falls back to blank field values). `routes`
        # builds the form's action and the "Back to books" link.
        #
        # @see app/templates/books/new.html.erb
        #
        # @api public
      class New < View
        config.template = "books/new"

        expose :book, default: nil
        expose :routes
        expose :notice, default: nil
      end
    end
  end
end
