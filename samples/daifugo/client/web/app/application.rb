require 'hyalite'
require 'menilite'
require_relative 'models/card'
require_relative 'models/player'
require_relative 'views/board_view'

Hyalite.render(Hyalite.create_element(BoardView), $document[".game-board"])
