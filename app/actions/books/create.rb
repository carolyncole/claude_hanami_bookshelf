# frozen_string_literal: true

# Hanami port of `BooksController#create` + `book_params`; the ActiveRecord
# save becomes a pattern-matched repo#create, the flash a query parameter.
module Bookshelf
  module Actions
    module Books
          # Persists a new book and redirects back to it with a flash notice.
          #
          # @see Bookshelf::Repos::BookRepo#create
          # @api public
      class Create < Bookshelf::Action
               # Handles an HTTP POST against `POST /books`.
               #
               # Extracts `title`/`author` from the `book` form params, creates
               # the row through the repository, and on `Success` redirects to
               # the created book carrying a `Book was successfully created.`
               # notice as a query parameter. On `Failure` it answers with HTTP
               # 422 and re-renders the new-book form.
               #
               # @return [void] redirects 302 to the created book, or renders 422
            def handle(request, response)
              params = book_params(request)

              case (result = books_repo.create(title: params[:title], author: params[:author]))
              in Success(book)
                response.redirect_to(
                   "#{routes.path(:book, id: book.id)}?notice=#{URI.encode_www_form_component('Book was successfully created.')}"
                 )
              in Failure(_error)
                response.status = :unprocessable_entity
                response.render(
                  Bookshelf::Views::Books::New.new,
                  book: nil,
                  routes: routes,
                  notice: notice(request)
                  )
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
