require 'faraday'
require './lib/stations'
require './lib/station'
require './lib/tide_station'

class TideImport

  def import(year = Time.now.year)
    stations.each do |station|
      station.import_tides
    end
  end

  def stations
    @stations ||= TideStation.all
  end

end

TideImport.new.import
