require 'nokogiri'
require 'open-uri'

module UrbanDictionary
  class Word
    attr_reader :word, :entries

    # Can raise SocketError if unable to connect to specified URL
    def self.from_url(url)
      html = open(url).read
      doc = Nokogiri::HTML(html)

      word = doc.css('.word').first.content.strip
      definitions = doc.css('.definition').map{|d| d.content.strip }
      examples = doc.css('.example').map{|e| e.content.strip }
      entries = definitions.zip(examples).map{|d,e| Entry.new(d, e)}

      Word.new(word, entries)
    end

    def initialize(word, entries)
      @word = word
      @entries = entries
    end

    def to_s
      @word
    end

    def size
      @word.size
    end
    alias :length :size
  end
end