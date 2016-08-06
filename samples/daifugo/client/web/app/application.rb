require 'hyalite'
require 'menilite'
require_relative 'models/card'
require_relative 'models/player'
require_relative 'views/board_view'

class AppView
  include Hyalite::Component
  include Hyalite::Component::ShortHand

  def render
    BoardView.el
  end
end

Hyalite.render(Hyalite.create_element(AppView), $document[".content"])
