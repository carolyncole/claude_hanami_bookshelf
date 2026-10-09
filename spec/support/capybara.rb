# frozen_string_literal: true

# Capybara support for the `type: :system` specs.
#
# These are the Hanami-idiomatic descendants of the original Rails
# `rails_helper` + `type: :system` specs. The original drove a real browser
# (selenium headless); here the driver is Capybara's no-browser `rack_test`,
# pointed at the Rack application Hanami exposes as `Hanami.app`. This is the
# natural translation: a system spec in Hanami is "drive the HTTP layer of
# `Hanami.app` and assert on what renders".
#
# NOTE: the HTTP layer (routes/actions/views) for `books` is not wired yet, so
# every `visit` lands on a 404. The specs therefore load and run but their
# content assertions fail -- this is the expected red state. As the actions and
# views get ported, they go green.
require "capybara"
require "capybara/rspec"

Capybara.app = Hanami.app
Capybara.default_driver = :rack_test

RSpec.configure do |config|
  config.include Capybara::DSL, type: :system
  config.include Capybara::RSpecMatchers, type: :system
end
