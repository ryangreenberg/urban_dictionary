require "spec_helper"
require "stringio"

describe UrbanDictionary::CLI do
  CLI = UrbanDictionary::CLI

  def suppress_exit(expected_status)
    begin
      yield
      fail "Expected block to exit with status #{expected_status}, but no SystemExit exception was raised"
    rescue SystemExit => e
      expect(e.status).to eql(expected_status)
    end
  end

  def mk_cli(str, dictionary = nil)
    config = CLI::Config.new(
      :args => str.to_argv,
      :stdout => Test::IO.new,
      :stderr => Test::IO.new,
    )
    config.update(:dictionary, dictionary) unless dictionary.nil?
    cli = CLI.new(config)
    [cli, config]
  end

  def mk_word(term, definitions, examples)
    UrbanDictionary::Word.new(
      term,
      Array(definitions).zip(Array(examples)).map {|ea| UrbanDictionary::Entry.new(*ea) }
    )
  end

  describe "#run" do
    it "outputs help when called with no arguments" do
      cli, config = mk_cli("")
      suppress_exit(0) { cli.run }
      expect(config.stdout).to include("Usage: urban_dictionary")
    end

    it "outputs error when word has no definition" do
      dictionary = double("dictionary", :define => nil)
      cli, config = mk_cli("undefined word", dictionary)
      suppress_exit(1) { cli.run }
      expect(config.stderr).to include("No definition found for 'undefined word'")
    end

    it "outputs a word's definition when found" do
      word = mk_word("sample word", "a definition", "an example")
      dictionary = double("dictionary", :define => word)
      cli, config = mk_cli(word.word, dictionary)
      cli.run
      expect(config.stdout).to include(word.word)
    end

    it "outputs a random word when --random is provided" do
      random_word = mk_word("random word", "random definition", "random example")
      dictionary = double("dictionary", :random_word => random_word)
      cli, config = mk_cli("--random", dictionary)
      cli.run
      expect(config.stdout).to include(random_word.word)
    end
  end
end
