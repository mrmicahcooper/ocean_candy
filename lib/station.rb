require 'csv'
require 'ostruct'
require './lib/stations'
require './lib/tide'

class Station < OpenStruct

  def self.find(station_id)
    raw_station = Stations.find {|row| row["station_id"] == station_id.to_s }
    new(raw_station.to_h)
  end

  def self.all
    Stations.map do |raw_station|
      new(raw_station.to_h)
    end
  end

  def to_hash
    {
      name: name,
      id: station_id,
      lattitude: lattitude,
      longitude: longitude
    }
  end

  def tides(year = Time.now.year)
    @tide_year = year
    raw_tides.map do |raw_tide|
      Tide.new(raw_tide.to_h)
    end
  end

  def tides_for_date(date)
    if date.nil?
      query_date = Time.now
    else
      query_date = Time.parse(date)
    end
    tides(query_date.year).select do |tide|
      tide.is_on_date?(query_date)
    end
  end

  private

  def raw_tides
    @tides_table ||= CSV.read(csv_file_name, headers: true)
  end

  def tide_year
    @tide_year
  end

  def csv_file_name
    "tides/station#{station_id}_year#{tide_year}.csv"
  end

end
