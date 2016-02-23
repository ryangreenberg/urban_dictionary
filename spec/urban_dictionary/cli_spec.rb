require "spec_helper"

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
      :stdout => TestHelpers::IO.new,
      :stderr => TestHelpers::IO.new,
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
      cli.run
      expect(config.stdout.content).to include("Usage: urban_dictionary")
    end

    it "outputs an error message when an invalid option is provided" do
      cli, config = mk_cli("--invalid-option")
      suppress_exit(1) { cli.run }
      expect(config.stderr.content).to include("invalid option: --invalid-option")
    end

    it "outputs error when word has no definition" do
      dictionary = double("dictionary", :define => nil)
      cli, config = mk_cli("undefined word", dictionary)
      suppress_exit(1) { cli.run }
      expect(config.stderr.content).to include("No definition found for 'undefined word'")
    end

    it "outputs a word's definition when found" do
      word = mk_word("sample word", "a definition", "an example")
      dictionary = double("dictionary", :define => word)
      cli, config = mk_cli(word.word, dictionary)
      cli.run
      expect(config.stdout.content).to include(word.word)
    end

    it "outputs a random word when --random is provided" do
      random_word = mk_word("random word", "random definition", "random example")
      dictionary = double("dictionary", :random_word => random_word)
      cli, config = mk_cli("--random", dictionary)
      cli.run
      expect(config.stdout.content).to include(random_word.word)
    end

    it "accepts --format to specify output format" do
      word = mk_word("a word", "a definition", "a example")
      dictionary = double("dictionary", :define => word)
      cli, config = mk_cli("--format=json a word", dictionary)
      cli.run
      obj = MultiJson.load(config.stdout.content)
      expect(obj).to include("word" => word.word)
    end

    it "accepts -n to limit number of definitions" do
      word = mk_word("complex word", ["def #1", "def #2", "def #3"], ["example #1", "example #2", "example #3"])
      dictionary = double("dictionary", :define => word)
      cli, config = mk_cli("-n 1 #{word.word}", dictionary)
      cli.run
      expect(config.stdout.content).to include("def #1")
      expect(config.stdout.content).not_to include("def #2")
      expect(config.stdout.content).not_to include("def #3")
    end
  end
end
