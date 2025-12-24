# frozen_string_literal: true

require "rails/railtie"
require "yaml"

module RailsOutofbandKeys
  # Railtie to integrate with Rails and automatically set key_path.
  class Railtie < Rails::Railtie
    config.rails_outofband_keys = RailsOutofbandKeys::Config.new

    config.before_configuration do |app|
      # Load file-based configuration.
      config_file = app.root.join("config", "rails_outofband_keys.yml")
      if config_file.file?
        data = YAML.safe_load_file(config_file.to_s, permitted_classes: [], aliases: false)
        data = {} unless data.is_a?(Hash)

        app.config.rails_outofband_keys.root_subdir = data["root_subdir"]
        if data.key?("credentials_subdir")
          app.config.rails_outofband_keys.credentials_subdir = data["credentials_subdir"]
        end
      end

      # Identify the app name for path resolution.
      app_name = app.railtie_name.to_s.underscore.sub(/_application$/, "")

      resolver = KeyResolver.new(
        config: app.config.rails_outofband_keys,
        rails_env: Rails.env,
        app_name: app_name
      )

      key_path = resolver.resolve_key_path
      next unless key_path

      app.config.credentials.key_path = key_path

      # Clear any early-cached credentials object to ensure the new path is used.
      app.remove_instance_variable(:@credentials) if app.instance_variable_defined?(:@credentials)
    end
  end
end
