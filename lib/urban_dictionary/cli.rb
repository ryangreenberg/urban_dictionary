require 'optparse'

module UrbanDictionary
  class CLI
    class Config
      # Constructor accepts an option hash with the following properties:
      PROPERTIES = [
        :args,       # ARGV input from the user (required)
        :stdout,     # IO object for writing to stdout (optional)
        :stderr,     # IO object for writing to stderr (optional)
        :dictionary, # Word-lookup object that implements .random_word and .define (optional)
      ]

      attr_reader *PROPERTIES

      def initialize(options)
        required(:args, options)
        optional(:stdout, options, STDOUT)
        optional(:stderr, options, STDERR)
        optional(:dictionary, options, UrbanDictionary)
      end

      def update(property, value)
        if PROPERTIES.include?(property)
          set(property, value)
        else
          raise ArgumentError, "#{property} is not a valid property (#{PROPERTIES.inspect})."
        end
      end

      private

      def required(property, hsh)
        unless hsh.include?(property)
          raise ArgumentError, "#{hsh.inspect} does not include required property #{property}"
        end
        set(property, hsh[property])
      end

      def optional(property, hsh, default)
        value = hsh.include?(property) ? hsh[property] : default
        set(property, value)
      end

      def set(property, value)
        instance_variable_set("@#{property}", value)
      end
    end

    attr_reader :options

    def initialize(config)
      @args = config.args
      @stdout = config.stdout
      @stderr = config.stderr
      @dictionary = config.dictionary
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
        @stdout.puts option_parser.help
        exit(0)
      end

      term = options[:remaining].join(" ")
      word = if options[:random]
        @dictionary.random_word
      else
        @dictionary.define(term)
      end

      if word.nil?
        @stderr.puts "No definition found for '#{term}'"
        exit(1)
      end

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

      @stdout.puts output.join("\n")
    end
  end
end
