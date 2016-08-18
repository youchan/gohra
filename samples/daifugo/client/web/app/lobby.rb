require 'hyalite'
require 'menilite'
require_relative 'push_message'
require_relative 'views/lobby_view'

PushMessage.init
Hyalite.render(Hyalite.create_element(LobbyView), $document[".content"])
