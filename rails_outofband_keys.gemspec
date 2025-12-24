# frozen_string_literal: true

require_relative "lib/rails_outofband_keys/version"

Gem::Specification.new do |spec|
  spec.name          = "rails_outofband_keys"
  spec.version       = RailsOutofbandKeys::VERSION
  spec.authors       = ["Lori Holden"]
  spec.email         = ["git@loriholden.com"]

  spec.summary       = "Load Rails credentials keys from outside your repo."
  spec.description = <<~DESC
    Configures Rails to load credentials master and environment key files from an out-of-band location
    (XDG on Linux/macOS, AppData on Windows) instead of the project directory.

    This reduces the risk of key exposure from tooling that reads or executes within your repo,
    including modern AI assistants and agentic tools.
  DESC

  spec.homepage      = "https://github.com/lholden/rails_outofband_keys"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 3.0"

  spec.files = Dir.glob("{lib}/**/*") + %w[README.md]
  spec.require_paths = ["lib"]

  spec.metadata["rubygems_mfa_required"] = "true"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.add_dependency "railties", ">= 6.0"
  spec.add_dependency "xdg", ">= 2.2"
end
