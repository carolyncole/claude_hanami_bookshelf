# auto_register: false
# frozen_string_literal: true

require "hanami/action"
require "dry/monads"

module Bookshelf
      # Base class for every HTTP action in the app.
      #
      # In Rails this role is played by `ApplicationController`
      # (`< ActionController::Base`). It centralises the two things every
      # action needs and that would otherwise be copy/pasted into each
      # controller method: the Hanami router
      # and a fresh {Bookshelf::Repos::BookRepo repository}.
      #
      # Hanami freezes an action instance in its initializer, so none of the
      # helpers below memoise onto instance variables -- they build a fresh
      # dependency on every call. That matches Rails' request-scoped
      # semantics anyway (a request gets its own controller instance).
      #
      # Because the default Hanami app ships without a session store, the
      # request-scoped {#notice flash} is read from the query string instead
      # of `flash[:notice]`.
      #
      # @see Bookshelf::Repos::BookRepo
      # @api public
  class Action < Hanami::Action
      # Provide `Success` and `Failure` so a handler can pattern-match a
      # `Dry::Monads::Result` from a repository instead of rescuing.
    include Dry::Monads[:result]

          # The application router, exposed to every view as `routes`.
          #
          # This is the Hanami stand-in for Rails' path helpers such as
          # `book_path` and `books_path`. The router is memoised on the
          # compiled app, so `router` is cheap; the action instance itself is
          # frozen, so it cannot memoise onto an ivar.
          #
          # @return [Hanami::Router::RouteSet] the compiled router
          # @see Bookshelf::App.router
    def routes
        Bookshelf::App.router
    end

          # A freshly-constructed {Bookshelf::Repos::BookRepo} -- the
          # request-scoped stand-in for `class Book < ApplicationRecord`.
          #
          # Built per call because an action instance is frozen by Hanami and
          # therefore cannot memoise a repository onto an ivar.
          #
          # @return [Bookshelf::Repos::BookRepo]
    def books_repo
       Repos::BookRepo.new
    end

          # Reads the flash notice carried as a query parameter.
          #
          # The Hanami stand-in for Rails' session-based `flash[:notice]`.
          # Success handlers redirect with `?notice=...`; this reads it back
          # on the following request so the view can render the banner.
          #
          # @param request [Hanami::HTTP::Request] the current request
          # @return [String, nil] the decoded notice, or `nil` when absent
    def notice(request)
       request.params[:notice]
    end
  end
end
