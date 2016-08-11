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
end
