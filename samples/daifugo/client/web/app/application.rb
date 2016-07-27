require 'hyalite'
require_relative 'views/deck'

Hyalite.render(Hyalite.create_element(Deck), $document[".deck"])
