# frozen_string_literal: true

require "rails/railtie"
require "yaml"

module RailsOutofbandKeys
  # Railtie to integrate with Rails and automatically set key_path.
  class Railtie < Rails::Railtie
    config.rails_outofband_keys = RailsOutofbandKeys::Config.new

    config.before_configuration do |app|
      # Load file-based configuration.
      config_file = File.join(Dir.getwd, "config", "rails_outofband_keys.yml")

      if File.exist?(config_file)
        external_config = YAML.load_file(config_file)
        app.config.rails_outofband_keys.root_subdir = external_config["root_subdir"]
        app.config.rails_outofband_keys.credentials_subdir = external_config.fetch("credentials_subdir", "credentials")
      end

      # Identify the app name for path resolution.
      app_name = app.railtie_name.to_s.underscore.sub(/_application$/, "")

      resolver = KeyResolver.new(
        config: app.config.rails_outofband_keys,
        rails_env: Rails.env,
        app_name: app_name
      )

      key_path = resolver.resolve_key_path
      if key_path
        app.config.credentials.key_path = key_path

        # Clear any early-cached credentials object to ensure the new path is used.
        app.remove_instance_variable(:@credentials) if app.instance_variable_defined?(:@credentials)
      end
    end
  end
end
