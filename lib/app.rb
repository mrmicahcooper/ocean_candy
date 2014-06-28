require "sinatra"
require "oj"
require "./lib/station"

class App < Sinatra::Base


  get "/" do
    '<h1>Ocean Candy</h1><a href="/stations">Stations JSON</a>'
  end

  get "/stations" do
    content_type :json

    set_headers

    Oj.dump(
      Station.all.group_by(&:state_name),
      mode: :compat
    )
  end

  get "/stations/:station_id/tides" do
    content_type :json

    station = Station.find(params[:station_id])
    tides = station.tides_for_date(params[:date])

    Oj.dump(
      tides.group_by{|t| t.tide},
      mode: :compat
    )

  end

  private

  def set_headers
    headers["Access-Control-Allow-Origin" ] = "*"
    headers["Access-Control-Request-Method"] = "GET"
  end

end
