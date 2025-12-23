# frozen_string_literal: true

require "rbconfig"
require "pathname"
require "xdg"

module RailsOutofbandKeys
  # Resolves the path to the credentials key file.
  class KeyResolver
    def initialize(config:, rails_env:, app_name:)
      @config = config
      @rails_env = rails_env
      @app_name = app_name
    end

    def resolve_key_path
      return nil if ENV["RAILS_MASTER_KEY"] && !ENV["RAILS_MASTER_KEY"].empty?

      key = find_key_in_resolved_dir
      enforce_permissions!(key) if key
      key&.to_s
    end

    private

    def find_key_in_resolved_dir
      dir = resolved_key_dir
      env_key = dir.join("#{@rails_env}.key")
      return env_key if env_key.file?

      master_key = dir.join("master.key")
      master_key.file? ? master_key : nil
    end

    def resolved_key_dir
      base = resolve_base_dir
      root = @config.root_subdir || @app_name

      path_parts = [base, root]
      path_parts << @config.credentials_subdir if @config.credentials_subdir

      Pathname.new(File.join(*path_parts))
    end

    public

    def resolve_base_dir
      # Specific application override
      override = ENV[@config.key_dir_env].to_s.strip
      return override unless override.empty?

      # Global base override
      global_base = ENV["RAILS_OUTOFBAND_BASE_DIR"].to_s.strip
      return global_base unless global_base.empty?

      return ENV.fetch("APPDATA") if Gem.win_platform?

      XDG.new.config_home.to_s
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
