require 'nokogiri'
require 'faraday'
require 'ostruct'
require 'csv'

module Service
  def url
    "http://co-ops.nos.noaa.gov/tide_predictions.html"
  end

  def conn
    Faraday.new(url: url)
  end

  def response_body
    @response_body ||= response.body
  end

  def response
    conn.get
  end
end

class StateImport
  include Service

  def import
    CSV.open('stations.csv', 'w') do |csv|
      csv << %w[state_gid state_name name station_id lattitude  longitude predictions]

      stations.each do |station|
        csv << station.as_array
      end
    end

  end

  def stations
    states.map(&:stations).flatten
  end

  def states
    doc = Nokogiri::HTML(response_body)
    doc.css('table a[href]').map do |el|
      State.new(el.text, el.attr('href')[/\d+$/])
    end
  end

  class State < Struct.new(:name, :gid)
    include Service

    def stations
      raw_stations.map do |el|
        row = el.css('td').map(&:text)
        Station.new(station_hash(row))
      end
    end

    def station_hash(row)
      {
        :state_gid   => gid,
        :state_name  => name,
        :name        => row[0].gsub(/&nbsp\s*/,""),
        :station_id  => row[1],
        :lattitude   => row[2],
        :longitude   => row[3],
        :predictions => row[4]
      }
    end

    def raw_stations
      Nokogiri::HTML(response_body).xpath("//table/tr[td/@class='stationid']")
    end

    def response
      conn.get do |request|
        request.params[:gid] = gid
      end
    end

  end

  class Station < OpenStruct
    def as_array
      to_h.values
    end
  end
end

# StateImport.new.import
