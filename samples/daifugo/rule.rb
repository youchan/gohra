deck include: joker(2)

state :field_cards, :cards, :any
state :used, :cards, :any
state :turns, :users

users do
  state :hand, :cards, :any
  state :up, :number
  state :pass, :flag, 1, false

  turn do |user|
    user.pass = false
    user.choose(:hand, 1..4) || user.pass = true
  end

  rule(:is_up?) do
    up.is_not 0
  end
end

rule(:turn_break?) do |user|
  r = users.except(user).all? {|u| puts "#{u.name}: #{u.pass.value}"; u.pass.value }
  puts "turn_break? #{r}"
  r
end

rule(:last_one_user?) do
  users.select(:is_up?).count == (users.count - 1)
end

progression do
  deck.shuffle
  deck.deal(users) do |user, card|
    user.hand << card
  end

  turns.cycle do |user|
    skip if user.is_up?
    user.turn
    turn_break?(user) do
      end_of_game if last_one_user?
    end
  end
end
