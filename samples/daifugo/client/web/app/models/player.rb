unless RUBY_ENGINE == 'opal'
  require 'bcrypt'
end

class Player < Menilite::Model
  field :name
  field :login
  field :password, :string, client: false

  action :signup, on_create: true do |password|
    self.password = BCrypt::Password.create(password)
    self.save
  end

  unless RUBY_ENGINE == 'opal'
    def auth(password)
      BCrypt::Password.new(self.password) == password
    end
  end
end
