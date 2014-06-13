require 'csv'
require 'ostruct'
require 'stations'

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


end

