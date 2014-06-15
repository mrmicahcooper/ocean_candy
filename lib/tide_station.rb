require 'ox'
require 'faraday'

class TideStation < Station

  attr_reader :import_year, :import_date

  def import_tides(year=Time.now.year)
    return false unless response.status == 200

    @import_year = year
    @import_date = Time.new(@import_year).strftime('%Y%m%d')
    if File.exists?(csv_file_name)
      return false
    end

    CSV.open(csv_file_name, 'w') do |csv|
      csv << %w[date day time inches centimeters tide]
      tides.each do |tide|
        csv << tide
      end
      puts station_id

    end
    true
  end

  def csv_file_name
    "tides/station#{station_id}_year#{import_year}.csv"
  end

  def tides
    tides_doc.locate("datainfo/data/item").map do |item|
      item.nodes.map(&:text)
    end
  end

  def tides_doc
    Ox.parse(response_body)
  end

  def response_body
    response.body
  end

  def response
    @response ||= Faraday.get(url) do |req|
      req.params['datatype']       = "Annual XML"
      req.params['Stationid']      = station_id
      req.params['bdate']          = import_date
      req.params['timelength']     = "daily"
      req.params['edate']          = import_date
      req.params['StationName']    = name
      req.params['primary']        = predictions
      req.params['datum']          = "MLLW"
      req.params['timeUnits']      = 2
      req.params['print_download'] = true
    end
  end

  def url
    "http://co-ops.nos.noaa.gov/noaatidepredictions/NOAATidesFacade.jsp"
  end

end
