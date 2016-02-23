require File.expand_path('../../lib/urban_dictionary', __FILE__)

require 'multi_json'
require 'shellwords'
require 'stringio'
require 'webmock/rspec'

module TestHelpers
  class IO < StringIO
    def content
      rewind
      read
    end
  end

  def load_fixture(name)
    File.read(File.expand_path("../html/#{name}", __FILE__))
  end
end

class String
  # Convert an input string to ARGV-like args as a shell would
  def to_argv
    Shellwords.split(self)
  end
end

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
  config.include TestHelpers
end
