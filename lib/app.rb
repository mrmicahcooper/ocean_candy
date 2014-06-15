require 'sinatra'
require 'oj'
require './lib/station'

class App < Sinatra::Base


  get '/' do
    "<h1>Ocean Candy</h1>"
  end

  get '/stations' do
    content_type :json
    stations = Station.all.map do |station|
      station.for_json
    end

    Oj.dump(stations, mode: :compat)
  end

end
