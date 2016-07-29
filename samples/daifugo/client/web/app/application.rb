require 'hyalite'
require 'menilite'
require_relative 'models/card'
require_relative 'views/hands_view'

Hyalite.render(Hyalite.create_element(HandsView), $document[".hands"])
