require "spec_helper"

describe UrbanDictionary do
  let(:result){ mock :result }

  describe "class method" do
    describe "#define" do
      it "should delegate to Word#from_url" do
        UrbanDictionary::Word.should_receive(:from_url).with("#{UrbanDictionary::DEFINE_URL}?term=pie").and_return(result)
        UrbanDictionary.define("pie").should eq(result)
      end

      it "should url encode the request" do
        UrbanDictionary::Word.should_receive(:from_url).with("#{UrbanDictionary::DEFINE_URL}?term=asdf%25asdf").and_return(result)
        UrbanDictionary.define("asdf%asdf").should eq(result)
      end
    end

    describe "#random_word" do
      let(:request){ mock :request }
      let(:response){ {'location' => 'location'} }
      let(:http){ mock :http }

      it "should do an HTTP GET to determine the random word" do
        Net::HTTP.should_receive(:start).with("www.urbandictionary.com", 80).and_yield(http).and_return(response)
        http.should_receive(:request).with(an_instance_of(Net::HTTP::Get))
        UrbanDictionary.should_receive(:define).with('location').and_return(result)
        UrbanDictionary.random_word.should eq(result)
      end
    end
  end
end
