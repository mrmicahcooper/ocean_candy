require 'sinatra'
require 'oj'
require './lib/station'

class App < Sinatra::Base


  get '/' do
    "<h1>Ocean Candy</h1><a href='/stations'>Stations JSON</a>"
  end

  get '/stations' do
    content_type :json

    Oj.dump(
      Station.all.map(&:to_h),
      mode: :compat
    )
  end

  get '/stations/:station_id/tides' do
    content_type :json

    station = Station.find(params[:station_id])
    tides = station.tides_for_date(params[:date])

    Oj.dump(
      tides.map(&:to_h),
      mode: :compat
    )

  end

end
