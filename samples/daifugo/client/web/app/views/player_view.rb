class PlayerView
  include Hyalite::Component
  include Hyalite::Component::ShortHand

  def render
    player = @props[:player]

    div({className: "player"},
      p(className: "player-icon"),
      p({className: "name"}, player.try(&:name))
    )
  end
end
