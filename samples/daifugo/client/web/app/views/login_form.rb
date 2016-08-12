require_relative '../controllers/application_controller.rb'

class LoginForm
  include Hyalite::Component
  include Hyalite::Component::ShortHand

  def initialize
    @state = { error: false }
  end

  def on_click
    username = @refs[:username].value
    password = @refs[:password].value

    controller = ApplicationController.new
    controller.login(username, password) do |status, result|
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
        input({class: 'input', ref: 'username', type: 'text', placeholder: 'Username'}),
        i({class: 'fa fa-user'})
      ),
      p({class: 'control has-icon'},
        input({class: 'input', ref: 'password', type: 'password', placeholder: 'Password'}),
        i({class: 'fa fa-lock'})
      ),
      p({class: 'control'},
        button({class: 'button is-primary', onClick: self.method(:on_click) }, "Login")
      )
    )
  end
end
