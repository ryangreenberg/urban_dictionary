require "spec_helper"

describe UrbanDictionary::Word do

  describe "instance method" do
    subject{ UrbanDictionary::Word.new("pie", [double, double]) }

    describe '#to_s' do
      subject { super().to_s }
      it { should eq("pie") }
    end

    describe '#size' do
      subject { super().size }
      it { should eq(3) }
    end

    describe '#length' do
      subject { super().length }
      it { should eq(3) }
    end
  end

  describe "class method" do
    describe "#from_url" do
      let(:url){ "the_url" }
      let(:html_with_results){ Test.load_fixture("on_fleek_2016-02-15.html") }
      let(:html_without_results){ Test.load_fixture("sisyphus_2016-02-15.html") }

      it "parses a valid word" do
        word = UrbanDictionary::Word.from_html(html_with_results)
        expect(word).to be_a(UrbanDictionary::Word)
        expect(word.word).to eq("on fleek")
        expect(word.entries.length).to eq(7)
        expect(word.entries.first).to be_an_instance_of(UrbanDictionary::Entry)
      end

      it "returns nil for unknown words" do
        expect(UrbanDictionary::Word.from_html(html_without_results)).to be_nil
      end
    end
  end
end
