class Player < Menilite::Model
  field :account, :reference
  field :game, :reference
  field :playing, :boolean, default: true
end
