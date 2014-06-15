require 'station'

describe Station do

  subject { described_class }

  describe '.find' do
    it "returns the station by station id" do
      expect(subject.find(8410834).name).to eq("PETTEGROVE POINT, DOCHET ISLAND")
    end
  end

  describe ".all" do
    it "returns all the stations" do
      expect(subject.all.count).to eq(3021)
      expect(subject.all.first).to be_a(Station)
    end
  end
end
