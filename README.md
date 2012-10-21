# Urban Dictionary #

`urban_dictionary` is a Ruby gem to access word definitions and examples from [Urban Dictionary](http://www.urbandictionary.com/). It also provides a command-line tool for getting definitions.

## Installation ##

Run `gem install urban_dictionary`.

## Usage ##

Get words using `UrbanDictionary.define` or `UrbanDictionary.random_word`. These methods return an instance of UrbanDictionary::Word, which has a list of entries, or nil if the word is not found. Each entry has a definition and an example.

    require 'urban_dictionary'

    word = UrbanDictionary.define("QED")
    word.entries.size # => 7
    word.entries.each do |entry|
      puts entry.definition
      puts entry.example
    end

## Command Line ##

The urban_dictionary gem includes a command-line interface:

    > urban_dictionary super salad
    super salad
    -----------

    1. A mythical dish of the best salad ever compiled
    ...
    ...

You can use the `--random` flag to get the definition of random word:

    > urban_dictionary --random

## Tests ##

Run examples with:

    rspec

