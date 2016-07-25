require 'sinatra'
require 'opal'

if development?
  require 'sinatra/reloader'
end

class Server < Sinatra::Base
  configure do
  end

  get '/' do
    haml :index
  end

  get "/favicon.ico" do
  end

end
