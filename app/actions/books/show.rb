# frozen_string_literal: true

# Hanami port of `BooksController#show` plus the `set_book` before-action;
# ActiveRecord's raising `find` becomes a pattern-matched repo#get.
module Bookshelf
  module Actions
    module Books
         # Shows one book by id, or renders a 404 when it is absent.
         #
         # @see Bookshelf::Views::Books::Show
         # @see Bookshelf::Repos::BookRepo#get
         # @api public
      class Show < Bookshelf::Action
              # Handles an HTTP GET against `GET /books/:id`.
              #
              # Looks the book up through the repository. On success it renders
              # the {Bookshelf::Views::Books::Show} view; on `Failure`
              # (the `set_book` before-action equivalent) it answers with HTTP
              # 404 and a plain "Book not found" body.
              #
              # @return [void] renders 200 with the show page, or 404 "not found"
            def handle(request, response)
              id = request.params[:id].to_i

              case (result = books_repo.get(id: id))
              in Success(book)
                response.render(
                  Bookshelf::Views::Books::Show.new,
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
