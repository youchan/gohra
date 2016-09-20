require 'hyalite'
require 'menilite'
require_relative 'views/login_form'

Hyalite.render(Hyalite.create_element(LoginForm), $document[".content"])
