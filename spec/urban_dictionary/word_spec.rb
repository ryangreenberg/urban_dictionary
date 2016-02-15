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
      let(:html_with_results){ Test.load_fixture("on_fleek_2016-02-15.html") }
      let(:html_without_results){ Test.load_fixture("sisyphus_2016-02-15.html") }

      it "parses a valid word" do
        word = UrbanDictionary::Word.from_html(html_with_results)
        word.should be_a(UrbanDictionary::Word)
        word.word.should eq("on fleek")
        word.entries.length.should eq(7)
        word.entries.first.should be_an_instance_of(UrbanDictionary::Entry)
      end

      it "returns nil for unknown words" do
        UrbanDictionary::Word.from_html(html_without_results).should be_nil
      end
    end
  end
end
