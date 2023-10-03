# frozen_string_literal: true

require_relative "lib/columns_trace/version"

Gem::Specification.new do |spec|
  spec.name = "columns_trace"
  spec.version = ColumnsTrace::VERSION
  spec.authors = ["fatkodima"]
  spec.email = ["fatkodima123@gmail.com"]

  spec.summary = "Find unnecessary selected database columns."
  spec.homepage = "https://github.com/fatkodima/columns_trace"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/master/CHANGELOG.md"

  spec.files = Dir["**/*.{md,txt}", "{lib}/**/*"]
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", ">= 6.0"
end
