# frozen_string_literal: true

require_relative "boot"

require "rails"
require "active_record/railtie"
require "active_job/railtie"
require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

module Dummy
  class Application < Rails::Application
    config.root = File.expand_path("..", __dir__)
    config.eager_load = false

    if Rails::VERSION::MAJOR >= 7
      config.load_defaults 7.0
    else
      config.load_defaults 6.0
    end
  end
end
