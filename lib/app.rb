require 'sinatra'

class App < Sinatra::Base

  get '/' do
    "<h1>Ocean Candy</h1>"
  end

end
