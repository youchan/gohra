class Session < Menilite::Model
  field :player, :reference
  field :session_id, :string, client: false
  field :login_at, :time, client: false
  field :expire_at, :time, client: false
  field :login, :boolean, default: true

  action :login_users, class: true do
    assoc = self.store.armodel(self).where(login: true)
    assoc.map{|ar| self.store.to_model(ar, self).to_h }.tap{|o| p o }
  end
end
