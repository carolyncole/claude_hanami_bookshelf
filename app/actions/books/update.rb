# frozen_string_literal: true

# Hanami port of `BooksController#update` + `book_params` + the `set_book`
# before-action; ActiveRecord's update becomes a pattern-matched repo#update.
module Bookshelf
  module Actions
    module Books
            # Updates a book by id and redirects back to it with a flash notice.
            #
            # @see Bookshelf::Repos::BookRepo#update
            # @api public
      class Update < Bookshelf::Action
                 # Handles an HTTP PATCH (or PUT) against `/books/:id`.
                 #
                 # Extracts `title`/`author` from the `book` form params and
                 # updates the row through the repository. On `Success` it
                 # redirects to the updated book carrying a `Book was
                 # successfully updated.` notice as a query parameter. On
                 # `Failure` (the `set_book` before-action equivalent -- the id
                 # matches no row) it answers with HTTP 404 and a plain "Book
                 # not found" body, mirroring the other member actions.
                 #
                 # @return [void] redirects 303 to the updated book, or renders 404
            def handle(request, response)
              id = request.params[:id].to_i
              params = book_params(request)

              case (result = books_repo.update(id: id, title: params[:title], author: params[:author]))
              in Success(book)
                response.redirect_to(
                   "#{routes.path(:book, id: book.id)}?notice=#{URI.encode_www_form_component('Book was successfully updated.')}",
                  status: 303
                  )
              in Failure(_error)
                response.status = :not_found
                response.body = "Book not found"
              end
            end

                    # Pulls the stringified `title`/`author` out of the `book`
                    # form params, tolerating both symbol and string keys.
                    #
                    # @param request [Hanami::HTTP::Request] the current request
                    # @return [Hash{String => String}] `{title:, author:}`
            private

            def book_params(request)
              form = request.params[:book] || {}
                {
                title: (form[:title] || form["title"]).to_s,
                author: (form[:author] || form["author"]).to_s,
                }
            end
      end
    end
  end
end
