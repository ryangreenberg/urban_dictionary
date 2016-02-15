require "spec_helper"

describe UrbanDictionary do
  let(:result){ double :result }

  describe "class method" do
    describe "#define" do
      it "delegates to Word#from_url" do
        expect(UrbanDictionary::Word).to receive(:from_url).with("#{UrbanDictionary::DEFINE_URL}?term=pie").and_return(result)
        expect(UrbanDictionary.define("pie")).to eq(result)
      end

      it "URL-encodes the request" do
        expect(UrbanDictionary::Word).to receive(:from_url).with("#{UrbanDictionary::DEFINE_URL}?term=asdf%25asdf").and_return(result)
        expect(UrbanDictionary.define("asdf%asdf")).to eq(result)
      end
    end

    describe "#random_word" do
      let(:request){ double :request }
      let(:url) { 'http://example.com' }
      let(:response){ {'location' => url } }
      let(:http){ double :http }

      it "should do an HTTP GET to determine the random word" do
        expect(Net::HTTP).to receive(:start).with("www.urbandictionary.com", 80).and_yield(http).and_return(response)
        expect(http).to receive(:request).with(an_instance_of(Net::HTTP::Get))
        expect(UrbanDictionary::Word).to receive(:from_url).with(url).and_return(result)
        expect(UrbanDictionary.random_word).to eq(result)
      end
    end
  end
end
