require 'hyalite'
require 'menilite'
require_relative 'models/card'
require_relative 'models/player'
require_relative 'views/players_view'
require_relative 'views/layout_view'
require_relative 'views/hands_view'

Hyalite.render(Hyalite.create_element(PlayersView), $document[".players-box"])
Hyalite.render(Hyalite.create_element(LayoutView), $document[".layout-placeholder"])
Hyalite.render(Hyalite.create_element(HandsView), $document[".hands"])
