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
    choice = user.choose(:hand, 1..4) {|cards|
      message = validate_user_choice(user, cards)
      if message
        puts message
        false
      else
        true
      end
    }

    user.pass = true if choice.nil?
    choice
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

rule(:validate_user_choice) do |user, cards|
  return "not same_number_of" unless same_number_of(cards)
  return nil if field_cards.count == 0
  return "not match count" unless field_cards.count == cards.count
  return "not same_suit_of" unless same_suit_of(cards)
  return "less than" unless cards[0].number > field_cards[0].number
  nil
end

rule(:same_suit_of) do |cards|
  cards.count > 1 || cards[0].suit == field_cards[0].suit
end

rule(:same_number_of) do |cards|
  cards.count == 1 || cards.all? {|c| cards[0].number == c.number }
end

progression do
  deck.shuffle
  deck.deal(users) do |user, card|
    user.hand << card
  end

  turns.cycle do |user|
    skip if user.is_up?
    cards = user.turn(self)
    used << field_cards
    field_cards.value = cards
    users.notice_all(:update_field, params: {user:user, cards: cards})
    turn_break?(user) do
      end_of_game if last_one_user?
    end
  end
end
