unless RUBY_ENGINE == 'opal'
  require 'gohra'
  require_relative '../models/gohra_player'
end

class GameController < Menilite::Controller
  def self.namespace
    'game'
  end

  action :start do
    rule = open(File.expand_path("../../../../daifugo/rule.rb", __FILE__)).read
    login_users = Session.login_users

    game = Game.create
    players = login_users.map{|user| Player.create(account_id: user[:account_id], game_id: game.id) }

    rule_engine = Gohra::RuleEngine.new(rule, players.map {|player| GohraPlayer.new(settings.sockets[player.id], player.account.name) })
    settings.engines[game.id] = rule_engine

    { status: 'ok' }
    # Thread.start do
    #   rule_engine.run
    # end
  end
end
