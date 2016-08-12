class ApplicationController < Menilite::Controller
  action :login do |username, password|
    player = Player.fetch(filter: {login: username}).first

    if player.auth(password)
      session[:player] = player
      player
    else
      raise "Login failed"
    end
  end
end
