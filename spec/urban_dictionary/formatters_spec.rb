require "spec_helper"

describe UrbanDictionary::PlainFormatter do
  let(:formatter) { UrbanDictionary::PlainFormatter }

  describe "#format" do
    it "converts carriage returns to new lines" do
      word = mk_word("term", "definition\rwith CR", "example\rwith CR")
      output = formatter.format(word)
      expect(output).to include("definition\nwith CR")
      expect(output).to include("example\nwith CR")
    end
  end
end

describe UrbanDictionary::JsonFormatter do
  let(:formatter) { UrbanDictionary::JsonFormatter }

  describe "#format" do
    it "converts carriage returns to new lines" do
      word = mk_word("term", "definition\rwith CR", "example\rwith CR")
      output = MultiJson.load(formatter.format(word))
      expected_output = [
        {"definition" => "definition\nwith CR", "example" => "example\nwith CR"}
      ]
      expect(output["entries"]).to eq(expected_output)
    end
  end
end
