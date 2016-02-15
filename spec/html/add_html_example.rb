#!/usr/bin/env ruby

# Save a given URL as a test case in the spec/html directory

require 'nokogiri'
require 'open-uri'
require 'uri'
require 'cgi'
require 'time'

USAGE = "Usage: #{$PROGRAM_NAME} url"

url = ARGV[0]
abort USAGE unless url

html = open(url) {|f| f.read }
file_name = begin
  uri = URI.parse(url)
  params = CGI.parse(uri.query || "")
  base_name = if params.include?('term')
    params['term'][0]
  else
    "#{uri.host}#{uri.path}"
  end

  %|#{base_name.downcase.gsub(/[^a-z0-9]/i, '_')}_#{Time.now.strftime("%Y-%m-%d")}.html|
end
file_path = File.join(File.expand_path('..', __FILE__), file_name)

doc = Nokogiri.HTML(html)

# Remove script tags and SVG elements to cut down on size
doc.css('script,g').remove

File.open(file_path, 'w') { |f| f << doc.to_html }
