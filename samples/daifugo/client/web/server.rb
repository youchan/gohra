require 'sinatra'

if development?
  require 'sinatra/reloader'
end

class Server < Sinatra::Base
  configure do
  end

  get '/' do
    @now = Time.now.month
    haml :index
  end
end

