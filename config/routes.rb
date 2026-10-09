# frozen_string_literal: true

# Hanami port of Rails' `resources :books` + `root "books#index"`.
#
# Each `as:` gives the route a name usable via `routes.path(:name, ...)` -- the
# stand-in for Rails' `book_path`/`books_path`/`new_book_path`/`edit_book_path`.
# The collection and member `as:` names mirror the RESTful `resources :books`
# expansion; `create`/`update`/`destroy` verb routes are unnamed because actions
# never generate URLs for them.

module Bookshelf
  class Routes < Hanami::Routes
     get        "/",            to: "books.index", as: :root
     get        "/books",       to: "books.index", as: :books
     get        "/books/new",   to: "books.new",   as: :new_book
     get        "/books/:id/edit", to: "books.edit", as: :edit_book
     get        "/books/:id",   to: "books.show",  as: :book
     post       "/books",       to: "books.create"
     patch      "/books/:id",   to: "books.update"
     delete     "/books/:id",   to: "books.destroy"
  end
end
