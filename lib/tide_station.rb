require 'ox'
require 'faraday'

class TideStation < Station

  attr_reader :import_year, :import_date

  def import_tides(year=Time.now.year)
    if response.status != 200
      puts station_id
      return false
    end

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
    end
    puts name + "-" + station_id
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
      req.params['datatype']             = "Annual XML"
      req.params['Stationid']            = station_id
      req.params['Stationid_']           = station_id
      req.params['bdate']                = import_date
      req.params['edate']                = import_date
      req.params['StationName']          = name
      req.params['primary']              = predictions
      req.params['datum']                = "MLLW"
      req.params['timeUnits']            = 2
      req.params['print_download']       = true

      req.params['ReferenceStationName'] = name
      req.params['ReferenceStation']     = station_id

      req.params['timelength']           = 'daily'
      req.params['timeZone']             = '2'
      req.params['dataUnits']            = '1'
      req.params['interval']             = ''

      req.params['pageview']             = 'dayly'
      req.params['print_download']       = 'true'

      req.headers['Accept']              = 'text/html,application/xhtml+xml,application/xml;q                                                          = 0.9,image/webp,*/*;q = 0.8'
      req.headers['Accept-Language']     = 'en-US,en;q                                                                                                 = 0.8'

    end
  end

  def url
    "http://co-ops.nos.noaa.gov/noaatidepredictions/NOAATidesFacade.jsp"
    # "http://140.90.78.215/noaatidepredictions/NOAATidesFacade.jsp"
  end

end
