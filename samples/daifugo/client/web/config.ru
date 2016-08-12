require 'bundler/setup'
Bundler.require(:default)

require 'menilite'
require_relative 'app/models/player.rb'
require_relative 'app/controllers/application_controller.rb'
require_relative 'server.rb'

app = Rack::Builder.app do
  map '/' do
    run Server.new(host: 'localhost')
  end

  map '/assets' do
    run Server::OPAL.sprockets
  end

  map '/__OPAL_SOURCE_MAPS__' do
    run Opal::SourceMapServer.new(Server::OPAL.sprockets, '/__OPAL_SOURCE_MAPS__')
  end

  map '/api' do
    router = Menilite::Router.new(Player, ApplicationController)
    run router.routes
  end
end

Rack::Server.start({
  app:    app,
  server: 'thin',
  Host:   '0.0.0.0',
  Port:   9292,
  signals: false,
})
