require 'sinatra'
require 'opal'
require 'opal/sprockets'
require 'sinatra/activerecord'
require 'sinatra-websocket'

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
    set sockets: []
    enable :sessions
  end

  get '/' do
    if session[:player]
      haml :index
    else
      redirect to('/login')
    end
  end

  get '/login' do
    haml :login
  end

  get '/signup' do
    haml :signup
  end

  get '/websocket' do
    if request.websocket? then
      request.websocket do |ws|
        ws.onopen do
          settings.sockets << ws
        end
        ws.onclose do
          settings.sockets.delete(ws)
        end
      end
    end
  end

  get "/favicon.ico" do
  end
end
