require File.expand_path('../../lib/urban_dictionary', __FILE__)
require 'shellwords'
require 'webmock/rspec'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end

module Test
  def self.load_fixture(name)
    File.read(File.expand_path("../html/#{name}", __FILE__))
  end

  class IO < StringIO
    def include?(str)
      rewind
      read.include?(str)
    end
  end
end

class String
  # Convert an input string to ARGV-like args as a shell would
  def to_argv
    Shellwords.split(self)
  end
end

