require 'hyalite'
require 'menilite'
require_relative 'views/signup_form'

Hyalite.render(Hyalite.create_element(SignupForm), $document[".content"])
