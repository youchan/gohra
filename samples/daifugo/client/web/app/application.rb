require 'hyalite'
require 'menilite'
require_relative 'models/card'
require_relative 'views/deck_view'

Hyalite.render(Hyalite.create_element(DeckView), $document[".hands"])
