require 'sinatra'
require 'opal'
require 'opal/sprockets'

if development?
  require 'sinatra/reloader'
end

class Server < Sinatra::Base
  OPAL = Opal::Server.new do |server|
    server.append_path 'app'
    server.append_path 'assets'
    Opal.use_gem 'hyalite'
    Opal.paths.each {|path| server.append_path path }

    server.main = 'application'
  end

  configure do
    set opal: OPAL
  end

  get '/' do
    haml :index
  end

  get '/signup' do
    haml :signup
  end

  get "/favicon.ico" do
  end
end
