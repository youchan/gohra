class Session < Menilite::Model
  field :account, :reference
  field :session_id, :string, client: false
  field :login_at, :time, client: false
  field :expire_at, :time, client: false
  field :login, :boolean, default: true

  action :login_users, class: true do
    assoc = self.store.armodel(self).where(login: true)
    assoc.map{|ar| self.store.to_model(ar, self).to_h }.tap{|o| p o }
  end

  unless RUBY_ENGINE == 'opal'
    def self.auth(session_id)
      session = Session.fetch(filter:{session_id: session_id}).first
      if session && session.expire_at > Time.now
        session.update!(expire_at: Time.now + 5 * 60)
      else
        session.update!(login: false) if login
        nil
      end
    end
  end
end
