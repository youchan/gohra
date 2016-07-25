require File.dirname(__FILE__) + '/server.rb'

opal = Opal::Server.new do |server|
  server.append_path 'app'
  server.append_path 'assets'
  Opal.use_gem 'hyalite'
  Opal.paths.each {|path| server.append_path path }

  server.main = 'application'
end

app = Rack::Builder.app do
  map '/' do
    run Server.new(host: 'localhost')
  end

  map '/assets' do
    run opal.sprockets
  end

  map '/__OPAL_SOURCE_MAPS__' do
    run Opal::SourceMapServer.new(opal.sprockets, '/__OPAL_SOURCE_MAPS__')
  end
end

Rack::Server.start({
  app:    app,
  server: 'thin',
  Host:   '0.0.0.0',
  Port:   9292,
  signals: false,
})
