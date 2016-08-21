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
    set sockets: {}
    set engines: {}
    enable :sessions
  end

  get '/' do
    if session = Session.auth(self.session[:session_id])
      @player = Player.fetch(filter:{account_id: session.account.id, playing: true}).first
      if @player
        haml :index
      else
        redirect to('/lobby')
      end
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

  get '/lobby' do
    if session = Session.auth(self.session[:session_id])
      haml :lobby
    else
      redirect to('/login')
    end
  end

  get '/websocket' do
    if request.websocket? then
      request.websocket do |ws|
        session = Session.auth(self.session[:session_id])
        ws.onopen do
          (settings.sockets[session.account.id] ||= [])<< ws
        end
        ws.onclose do
          settings.sockets[session.account.id].delete(ws)
        end
      end
    end
  end

  get "/favicon.ico" do
  end
end
