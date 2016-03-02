require 'multi_json'

module UrbanDictionary
  class Formatter
    class Util
      PATTERN = Regexp.compile(/\r\n|\r|\n/)
      NEW_LINE = "\n"

      def self.convert_linebreaks(str)
        str.gsub(PATTERN, NEW_LINE)
      end
    end

    def self.register(name, klass)
      @formatters ||= {}
      if @formatters.include?(name)
        raise RuntimeError, "Formatter #{@formatters[name]} already registered for '#{name}'"
      else
        @formatters[name] = klass
      end
    end

    def self.for(name)
      @formatters[name]
    end

    def self.registered
      @formatters.keys.map()
    end

    def self.format(word)
      raise NotImplementedError, "#format has not been implemented by #{self}"
    end
  end

  class PlainFormatter < Formatter
    def self.format(word)
      output = []
      output << word
      output << '-' * word.size
      output << ''
      word.entries.each_with_index do |entry, i|
        output << "#{i + 1}. #{Util.convert_linebreaks(entry.definition)}"
        output << ""
        output << "Example: #{Util.convert_linebreaks(entry.example)}"
        output << ""
        output << ""
      end
      output.join("\n")
    end
  end

  class JsonFormatter < Formatter
    def self.format(word)
      hsh = {
        :word => word.word,
        :entries => word.entries.map do |entry|
          {
            :definition => Util.convert_linebreaks(entry.definition),
            :example => Util.convert_linebreaks(entry.example)
          }
        end
      }
      MultiJson.dump(hsh)
    end
  end
end
