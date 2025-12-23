# frozen_string_literal: true

require "rails/railtie"

module RailsOutofbandKeys
  class Railtie < Rails::Railtie
    config.rails_outofband_keys = RailsOutofbandKeys::Config.new

    initializer "rails_outofband_keys.configure", before: :load_environment_config do |app|
      resolver = KeyResolver.new(
        config: app.config.rails_outofband_keys,
        rails_env: Rails.env,
        app_name: app.railtie_name
      )

      key_path = resolver.resolve_key_path
      app.config.credentials.key_path = key_path if key_path
    end
  end
end
