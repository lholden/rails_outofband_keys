# frozen_string_literal: true

require_relative "lib/rails_outofband_keys/version"

Gem::Specification.new do |spec|
  spec.name          = "rails_outofband_keys"
  spec.version       = RailsOutofbandKeys::VERSION
  spec.authors       = ["Lori Holden"]
  spec.email         = ["git@loriholden.com"]
  spec.summary       = "Resolve Rails credentials key files outside the project tree (XDG/AppData + overrides)."
  spec.description   = <<~DESC
    Configures Rails credentials key_path to load environment/master key files
    from an out-of-band directory (XDG on Unix, AppData on Windows).
  DESC
  spec.homepage      = "https://github/lholden/rails_outofband_keys"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 3.0"

  spec.files = Dir.glob("{lib}/**/*") + %w[README.md]
  spec.require_paths = ["lib"]

  spec.add_dependency "railties", ">= 6.0"
  spec.add_dependency "xdg", ">= 2.2"
  spec.metadata["rubygems_mfa_required"] = "true"
end
