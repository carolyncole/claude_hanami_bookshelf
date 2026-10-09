# frozen_string_literal: true

module Bookshelf
  module Views
    module Helpers
       # View helpers shared across the app's `.erb` templates.
       #
       # Hanami auto-mixes this module into every template scope (see
       #  {Hanami::Extensions::View::SliceConfiguredHelpers}), alongside the
       # standard tag helpers (`link_to`, `tag`, `escape`) that Hanami already
       # provides.
       #
       # The Bookshelf views need no extra helper: the destroy form that
       # Rails' `button_to` renders is inlined literally in
       # `app/templates/books/show.html.erb` (a self-submitting `POST` form
       # with a hidden `_method`), which keeps the DOM unescaped and
       # Capybara-friendly.
       #
       # @see Bookshelf::Views
       #
       # @api public
    end
  end
end
