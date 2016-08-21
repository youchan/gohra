require_relative '../controllers/application_controller.rb'

class LoginForm
  include Hyalite::Component
  include Hyalite::Component::ShortHand

  def initialize
    @state = { error: false }
  end

  def on_keypress(event)
    if event.code == 13
      submit
    end
  end

  def submit
    username = @refs[:username].value
    password = @refs[:password].value

    ApplicationController.login(username, password) do |status, result|
      case status
      when :success
        `window.location = '/'`
      when :error
        puts "error"
      end
    end
  end

  def render
    div({class: 'login-form'},
      h3({}, "Login"),
      p({class: 'control has-icon'},
        input({class: 'input', ref: 'username', type: 'text', placeholder: 'Username', onKeyPress: self.method(:on_keypress)}),
        i({class: 'fa fa-user'})
      ),
      p({class: 'control has-icon'},
        input({class: 'input', ref: 'password', type: 'password', placeholder: 'Password', onKeyPress: self.method(:on_keypress)}),
        i({class: 'fa fa-lock'})
      ),
      p({class: 'has-text-right'}, a({href: '/signup'}, '> Create account')),
      p({class: 'control'},
        button({class: 'button is-primary', onClick: self.method(:submit) }, "Login")
      )
    )
  end
end
