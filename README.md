# Urban Dictionary #

`urban_dictionary` is a Ruby gem to access word definitions and examples from [Urban Dictionary](http://www.urbandictionary.com/).

## Installation ##

Run `gem install urban_dictionary`.

## Usage ##

Get words using `UrbanDictionary.define` or `UrbanDictionary.random_word`. These methods return an instance of UrbanDictionary::Word, which has a list of entries. Each entry has a definition and an example.

    word = UrbanDictionary.define("QED")
    word.entries.size # => 7
    word.entries.each do |entry|
      puts entry.definition
      puts entry.example
    end