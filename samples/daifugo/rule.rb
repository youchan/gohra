deck include: joker(2)

state :tableau, :cards, :any
state :used, :cards, :any
state :turns, :users

users do
  state :hand, :cards, :any
  state :choice, :cards, 1..4
  state :up, :number
  state :pass, :flag, 1, false

  turn do |user|
    user.choose_from_hand
  end

  rule(:choose_from_hand) do
    pass = false
    choice.value = choose(:hand, 1..4) {|cards| validate_choice(cards) }
    pass = true if choice.nil?
  end

  rule(:is_up?) do
    up.is_not 0
  end

  rule(:validate_choice) do |cards|
    same_number_of(cards)
    next if tableau.count == 0
    raise "not match count" unless tableau.count == cards.count
    same_suit_of(cards)
    greater_than(cards)

    true
  end

  rule(:same_suit_of) do |cards|
    return unless cards.count == 1
    return if cards[0] == Card::JOKER || tableau[0] == Card::JOKER
    raise "validate error: same suit of" if cards[0].suit != tableau[0].suit
  end

  rule(:same_number_of) do |cards|
    raise "validate error: same number of" if cards.count > 1 && cards.any? {|c| cards[0].number != c.number }
  end

  rule(:greater_than) do |cards|
    num = cards[0].number
    num = 14 if num == 1
    num = 15 if num == 0
    tableau_num = tableau[0].number
    tableau_num = 14 if tableau_num == 1
    tableau_num = 15 if tableau_num == 0
    raise "validate error: less than" if num <= tableau_num
  end
end

rule(:put_user_choice_on_tableau) do |user|
  used << tableau
  self.tableau = user.choice.value
  users.notice_all(:update_tableau, params: {user:user, cards: user.choice})
end

rule(:turn_break?) do |user|
  users.except(user).all? {|u| puts "#{u.name}: #{u.pass.value}"; u.pass.value }
end

rule(:last_one_user?) do
  users.select(:is_up?).count == (users.count - 1)
end

rule(:clear_tableau) do
  tableau.clear
end

progression do
  deck.shuffle
  deck.deal(users) do |user, card|
    user.hand << card
  end

  users.each do |user|
    user.hand.sort
  end

  turns.cycle do |user|
    skip if user.is_up?
    user.turn(self)
    put_user_choice_on_tableau(user)
    turn_break?(user) do
      clear_tableau
      end_of_game if last_one_user?
    end
  end
end
