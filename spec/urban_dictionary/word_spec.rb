require "spec_helper"

describe UrbanDictionary::Word do
  
  describe "instance method" do
    subject{ UrbanDictionary::Word.new("pie", [mock, mock]) }

    its(:to_s){ should eq("pie") }
    its(:size){ should eq(3) }
    its(:length){ should eq(3) }
  end

  describe "class method" do
    describe "#from_url" do
      let(:url){ "the_url" }
      let(:html_with_results){ File.open(File.expand_path("../../html/test_with_results.html", __FILE__)) }
      let(:html_without_results){ File.open(File.expand_path("../../html/test_without_results.html", __FILE__)) }

      it "should parse a valid word" do
        UrbanDictionary::Word.should_receive(:open).with(url).and_return(html_with_results)

        word = UrbanDictionary::Word.from_url(url)
        word.should be_a(UrbanDictionary::Word)
        word.word.should eq("test1234")
        word.entries.length.should eq(1)
        word.entries.first.should be_an_instance_of(UrbanDictionary::Entry)
      end

      it "should gracefully handle an unknown word by returning nil" do
        UrbanDictionary::Word.should_receive(:open).with(url).and_return(html_without_results)
        UrbanDictionary::Word.from_url(url).should be_nil
      end
    end
  end
end
