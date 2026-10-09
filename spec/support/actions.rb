# frozen_string_literal: true

require "rack/mock"

# Drives an action through the full Hanami rack stack
# (`Hanami.app.call`) and wraps the result in a {Rack::MockResponse} for
# assertions -- the browser-less counterpart to the Capybara system specs.
#
# The action specs exercise the routing + action + view chain directly, so
# they stay fast and don't need a browser, while still catching status codes,
# redirect locations and rendered HTML.
module ActionResponse
    # Sends one HTTP request through {Hanami.app} and returns a
    # {Rack::MockResponse} for convenient status / header / body assertions.
    #
    # @param path [String] the request path, e.g. "/books/1".
    # @param method [Symbol] the HTTP verb (`:get`, `:post`, `:patch`, `:delete`).
    # @param params [Hash] the request params (nested hashes are parsed).
    # @return [Rack::MockResponse] the action's response, wrapped for inspection.
  def request(path:, method: :get, params: {})
    env = Rack::MockRequest.env_for(path, method: method, params: params)
    status, headers, body = Hanami.app.call(env)
    Rack::MockResponse.new(status, headers, body)
  end
end
