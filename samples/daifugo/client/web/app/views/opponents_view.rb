require_relative 'player_view'

class OpponentsView
  include Hyalite::Component
  include Hyalite::Component::ShortHand

  def component_will_mount
    @opponents = (1..3).map {|i| Account.new(name: "Player #{i}") }
  end

  def render
    ul({className: 'opponents'}, @props[:opponents].map {|player| li(nil, PlayerView.el(player:player)) })
  end
end
