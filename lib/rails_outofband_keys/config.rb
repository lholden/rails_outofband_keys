# frozen_string_literal: true

module RailsOutofbandKeys
  # Configuration for RailsOutofbandKeys.
  class Config
    attr_accessor :root_subdir, :credentials_subdir, :key_dir_env

    def initialize
      @root_subdir = nil
      @credentials_subdir = "credentials"
      @key_dir_env = "RAILS_CREDENTIALS_KEY_DIR"
    end
  end
end
