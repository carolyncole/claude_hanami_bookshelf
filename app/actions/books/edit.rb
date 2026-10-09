# frozen_string_literal: true

# Hanami port of `BooksController#edit` plus the `set_book` before-action.
module Bookshelf
  module Actions
    module Books
           # Renders the "edit book" form for an existing book.
           #
           # @see Bookshelf::Views::Books::Edit
           # @see Bookshelf::Repos::BookRepo#get
           # @api public
      class Edit < Bookshelf::Action
                # Handles an HTTP GET against `GET /books/:id/edit`.
                #
                # Looks the book up through the repository (the `set_book`
                # before-action equivalent). On `Success` it renders the
                # {Bookshelf::Views::Books::Edit} view with the book loaded; on
                # `Failure` it answers with HTTP 404 and a plain "Book not
                # found" body.
                #
                # @return [void] renders 200 with the edit form, or 404 "not found"
            def handle(request, response)
              id = request.params[:id].to_i

              case (result = books_repo.get(id: id))
              in Success(book)
                response.render(
                  Bookshelf::Views::Books::Edit.new,
                  book: book,
                  routes: routes,
                  notice: notice(request),
                    )
              in Failure(_error)
                response.status = :not_found
                response.body = "Book not found"
              end
            end
      end
    end
  end
end
