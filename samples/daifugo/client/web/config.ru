require 'bundler/setup'
Bundler.require(:default)

require File.dirname(__FILE__) + '/server.rb'

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
end

Rack::Server.start({
  app:    app,
  server: 'thin',
  Host:   '0.0.0.0',
  Port:   9292,
  signals: false,
})
