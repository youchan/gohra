require 'browser/location'
require_relative '../models/account'

class SignupForm
  include Hyalite::Component
  include Hyalite::Component::ShortHand

  def initialize
    @state = { error: false }
  end

  def on_click
    display_name = @refs['display-name'].value
    username = @refs['username'].value
    password = @refs['password'].value

    model = Account.new(name: display_name, uid: username)
    model.signup(password) do |status|
      case status
      when :success
        $window.location.uri = '/'
      when :failure
        set_state(error: true)
      end
    end
  end

  def render
    notification = @state[:error] ? div({class: 'notification is-danger '}, "エラーです") : nil

    div({class: 'signup-form'},
      h3({}, "Signup"),
      notification,
      p({class: 'control has-icon'},
        input({class: 'input', ref: 'display-name', type: 'text', placeholder: 'Display name'}),
        i({class: 'fa fa-smile-o'})
      ),
      p({class: 'control has-icon'},
        input({class: 'input', ref: 'username', type: 'text', placeholder: 'Username'}),
        i({class: 'fa fa-user'})
      ),
      p({class: 'control has-icon'},
        input({class: 'input', ref: 'password', type: 'password', placeholder: 'Password'}),
        i({class: 'fa fa-lock'})
      ),
      p({class: 'control'},
        button({class: 'button is-primary', onClick: self.method(:on_click) }, "Signup")
      )
    )
  end
end
