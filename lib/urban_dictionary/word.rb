# encoding: UTF-8

require 'nokogiri'
require 'open-uri'

module UrbanDictionary
  class Word
    attr_reader :word, :entries

      # Can raise SocketError if unable to connect to specified URL
    def self.from_url(url)
      html = open(url) {|f| f.read }
      from_html(html)
    end

    def self.from_html(html)
      doc = Nokogiri.HTML(html)
      words = doc.css('.word')
      return nil if words.empty?

      word = words.first.content.strip
      definitions = doc.css('div.meaning').map {|d| d.content.strip }
      examples = doc.css('.example').map {|e| e.content.strip }
      entries = definitions.zip(examples).map {|d,e| Entry.new(d, e) }

      defined_word?(word, definitions) ? Word.new(word, entries) : nil
    end

    # Currently when a word has no definition the result page returns the
    # shrug emoticon (¯\_(ツ)_/¯) and the text "There aren't any definitions
    # for [word] yet."
    def self.defined_word?(word, definitions)
      undefined_word = (
        definitions.size == 1 &&
        definitions[0] =~ /^There aren't any definitions for/
      )
      !undefined_word
    end
    private_class_method :defined_word?

    def initialize(word, entries)
      @word = word
      @entries = entries
    end

    def to_s
      @word
    end

    def inspect
      "<#{self.class} @word=#{word.inspect}, @entries=#{entries.inspect}>"
    end

    def size
      @word.size
    end
    alias :length :size
  end
end

