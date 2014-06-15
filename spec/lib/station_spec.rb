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

  describe "#tides" do
    it "shows all tides" do
      expect(Station.all.first.tides).to be_a(Array)
    end
    it "is a collection of Tides" do
      expect(subject.all.first.tides.first).to be_a(Tide)
    end
  end

  describe "#tides_for_date" do
    it "shows all tides for a passed in date" do
      tides = subject.all.first.tides_for_date("2014-06-06")
      expect(tides.count).to eq(4)
    end

    it "shows all tides for today when now date is passed in" do
      tides = subject.all.first.tides_for_date(nil)
      expect(tides.count).to eq(4)
    end
  end

end
