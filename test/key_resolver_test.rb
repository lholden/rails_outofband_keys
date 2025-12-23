# frozen_string_literal: true

require "test_helper"

class KeyResolverTest < Minitest::Test
  def setup
    @config = RailsOutofbandKeys::Config.new
    @app_name = "test_app"
    @rails_env = "production"
  end

  def test_resolves_key_path_from_env_override
    with_temp_dir do |temp_dir|
      # Create a fake key file in our sandbox
      key_dir = temp_dir.join("test_app", "credentials")
      FileUtils.mkdir_p(key_dir)
      key_file = key_dir.join("production.key")
      File.write(key_file, "secret-key")
      File.chmod(0o600, key_file)

      with_env("RAILS_CREDENTIALS_KEY_DIR" => temp_dir.to_s) do
        resolver = RailsOutofbandKeys::KeyResolver.new(
          config: @config,
          rails_env: @rails_env,
          app_name: @app_name
        )

        assert_equal key_file.to_s, resolver.resolve_key_path
      end
    end
  end

  def test_raises_error_on_insecure_permissions
    skip if Gem.win_platform? # Permissions work differently on Windows

    with_temp_dir do |temp_dir|
      key_dir = temp_dir.join("test_app", "credentials")
      FileUtils.mkdir_p(key_dir)
      key_file = key_dir.join("production.key")
      File.write(key_file, "secret-key")

      # Set "bad" permissions (world readable)
      File.chmod(0o666, key_file)

      with_env("RAILS_CREDENTIALS_KEY_DIR" => temp_dir.to_s) do
        resolver = RailsOutofbandKeys::KeyResolver.new(
          config: @config,
          rails_env: @rails_env,
          app_name: @app_name
        )

        assert_raises RailsOutofbandKeys::InsecureKeyPermissionsError do
          resolver.resolve_key_path
        end
      end
    end
  end

  def test_returns_nil_if_rails_master_key_is_present
    with_env("RAILS_MASTER_KEY" => "already-set") do
      resolver = RailsOutofbandKeys::KeyResolver.new(
        config: @config,
        rails_env: @rails_env,
        app_name: @app_name
      )

      assert_nil resolver.resolve_key_path
    end
  end
end
