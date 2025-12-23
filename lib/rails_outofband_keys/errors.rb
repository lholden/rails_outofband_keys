# frozen_string_literal: true

module RailsOutofbandKeys
  class Error < StandardError; end

  class InsecureKeyPermissionsError < Error
    def initialize(path, mode)
      super("Insecure permissions on #{path} (#{mode}); expected 0600 or 0400")
    end
  end
end
