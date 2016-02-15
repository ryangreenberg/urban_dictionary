module UrbanDictionary
  class Entry
    attr_reader :definition, :example

    def initialize(definition, example)
      @definition = definition
      @example = example
    end

    def to_s
      "#{definition}\n#{example}"
    end

    def inspect
      "<#{self.class} @definition=#{definition.inspect}, @example=#{example.inspect}>"
    end
  end
end