# frozen_string_literal: true

module Bookshelf
  class Routes < Hanami::Routes
    root to: "books.index"

    get "/books", to: "books.index"
    get "/books/new", to: "books.new"
    post "/books", to: "books.create"
    get "/books/:id", to: "books.show"
    get "/books/:id/edit", to: "books.edit"
    patch "/books/:id", to: "books.update"
    delete "/books/:id", to: "books.destroy"
  end
end
