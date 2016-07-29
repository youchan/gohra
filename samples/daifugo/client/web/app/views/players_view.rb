require_relative 'player_view'

class PlayersView
  include Hyalite::Component
  include Hyalite::Component::ShortHand

  def component_will_mount
    @players = (1..3).map {|i| Player.new(name: "Player #{i}") }
  end

  def render
    ul({}, @players.map {|player| PlayerView.el(player:player) })
  end
end
