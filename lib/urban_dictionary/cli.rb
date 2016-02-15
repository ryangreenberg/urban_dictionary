require 'optparse'

module UrbanDictionary
  class CLI
    attr_reader :options

    def initialize(args)
      @args = args
      @options = {}
    end

    def option_parser
      @option_parser ||= OptionParser.new do |opts|
        opts.banner = "Usage: urban_dictionary <word or phrase>"
        opts.version = UrbanDictionary::VERSION

        opts.on("-r", "--random", "Define a random word") do |r|
          options[:random] = r
        end
      end
    end

    def run
      options[:remaining] = option_parser.parse(@args)

      if options[:remaining].empty? && !options[:random]
        puts option_parser.help
        exit(0)
      end

      term = options[:remaining].join(" ")
      word = if options[:random]
        UrbanDictionary.random_word
      else
        UrbanDictionary.define(term)
      end

      abort "No definition found for '#{term}'" if word.nil?

      output = []
      output << word
      output << '-' * word.size
      output << ''
      word.entries.each_with_index do |entry, i|
        output << "#{i + 1}. #{entry.definition}"
        output << ""
        output << "Example: #{entry.example}"
        output << ""
        output << ""
      end
      puts output.join("\n")
    end
  end
end
