require 'uri'
require 'net/http'

require_relative 'urban_dictionary/version'
require_relative 'urban_dictionary/cli'
require_relative 'urban_dictionary/word'
require_relative 'urban_dictionary/entry'

module UrbanDictionary
  DEFINE_URL = 'http://www.urbandictionary.com/define.php'
  RANDOM_URL = 'http://www.urbandictionary.com/random.php'

  def self.define(str)
    Word.from_url("#{DEFINE_URL}?term=#{URI.encode(str)}")
  end

  def self.random_word
    url = URI.parse(RANDOM_URL)
    req = Net::HTTP::Get.new(url.path)
    rsp = Net::HTTP.start(url.host, url.port) do |http|
      http.request(req)
    end

    Word.from_url(rsp['location'])
  end
end