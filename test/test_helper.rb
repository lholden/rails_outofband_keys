# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "active_support/all"
require "rails_outofband_keys"

require "minitest/autorun"
require "minitest/reporters"
require "tmpdir"
require "fileutils"

Minitest::Reporters.use!(Minitest::Reporters::DefaultReporter.new(color: true))

module TestHelpers
  def with_temp_dir
    Dir.mktmpdir do |dir|
      yield Pathname.new(dir)
    end
  end

  def with_env(hash)
    old_env = hash.keys.each_with_object({}) { |k, h| h[k] = ENV.fetch(k, nil) }
    hash.each { |k, v| ENV[k] = v }
    yield
  ensure
    old_env.each { |k, v| ENV[k] = v }
  end
end

module Minitest
  class Test
    include TestHelpers
  end
end
