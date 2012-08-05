require 'uri'
require 'net/http'

require 'urban_dictionary/version'
require 'urban_dictionary/word'
require 'urban_dictionary/entry'

module UrbanDictionary
  DEFINE_URL = 'http://www.urbandictionary.com/define.php'
  RANDOM_URL = 'http://www.urbandictionary.com/random.php'

  def self.define(str)
    Word.from_url("#{DEFINE_URL}?term=#{URI.encode(str)}")
  end

  def self.random_word
    url = URI.parse(RANDOM_URL)
    req = Net::HTTP::Get.new(url.path)
    rsp = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }

    Word.from_url(rsp['location'])
  end
end