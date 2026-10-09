# frozen_string_literal: true

# Hanami port of `BooksController#destroy` + the `set_book` before-action.
module Bookshelf
  module Actions
    module Books
           # Deletes a book by id and redirects back to the index.
           #
           # @see Bookshelf::Repos::BookRepo#delete
           # @api public
      class Destroy < Bookshelf::Action
                # Handles an HTTP DELETE against `DELETE /books/:id`.
                #
                # Deletes the row through the repository. On `Success` it
                # redirects to the books index with a `Book was successfully
                # destroyed.` notice as a query parameter; on `Failure` it
                # answers with HTTP 404 and a plain "Book not found" body.
                # (The current repository `delete` is idempotent and always
                # returns a `Success`, so the `Failure` branch is defensive.)
                #
                # @return [void] redirects 303 to the index, or renders 404
            def handle(request, response)
              id = request.params[:id].to_i

              case (result = books_repo.delete(id: id))
              in Success(_deleted)
                response.redirect_to(
                   "#{routes.path(:books)}?notice=#{URI.encode_www_form_component('Book was successfully destroyed.')}",
                  status: 303
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
