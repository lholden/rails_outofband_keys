# frozen_string_literal: true

require "rbconfig"
require "pathname"
require "xdg"

module RailsOutofbandKeys
  class KeyResolver
    def initialize(config:, rails_env:, app_name:)
      @config = config
      @rails_env = rails_env
      @app_name = app_name
    end

    def resolve_key_path
      return nil if ENV["RAILS_MASTER_KEY"] && !ENV["RAILS_MASTER_KEY"].empty?

      base = resolve_base_dir
      root = if @config.root_subdir.respond_to?(:call)
               @config.root_subdir.call(@app_name)
             else
               @config.root_subdir || @app_name
             end

      # Logic to allow skipping the credentials subfolder if set to nil
      path_parts = [base, root]
      path_parts << @config.credentials_subdir if @config.credentials_subdir
      dir = Pathname.new(File.join(*path_parts))

      env_key = dir.join("#{@rails_env}.key")
      master_key = dir.join("master.key")

      key = if env_key.file?
              env_key
            else
              (master_key.file? ? master_key : nil)
            end
      enforce_permissions!(key) if key
      key&.to_s
    end

    def resolve_base_dir
      # If this specific app has an absolute override, return it directly.
      # Pathname#join will ignore the 'base' if 'root' is absolute anyway,
      # but we'll stick to the current logic for specific overrides.
      override = ENV[@config.key_dir_env].to_s.strip
      return override unless override.empty?

      # Use a global base directory if set, otherwise fallback to OS defaults.
      global_base = ENV["RAILS_OUTOFBAND_BASE_DIR"].to_s.strip
      return global_base unless global_base.empty?

      return ENV.fetch("APPDATA", nil) if Gem.win_platform?

      XDG.config_home.to_s
    end

    def enforce_permissions!(path)
      return if Gem.win_platform?

      mode = File.stat(path).mode & 0o777

      owner_only = mode.nobits?(0o077)
      readable = mode.anybits?(0o400)

      return if owner_only && readable

      raise InsecureKeyPermissionsError.new(path, format("0%o", mode))
    end

  end
end
