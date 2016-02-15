require "spec_helper"

describe UrbanDictionary::Entry do
  describe "#to_s" do
    it "should print out the formatted example and definition" do
      expect(UrbanDictionary::Entry.new("pie", "delicious").to_s).to eq("pie\ndelicious")
    end
  end
end
