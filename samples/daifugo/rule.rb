deck include: joker(2)

state :tableau, :cards, :any
state :used, :cards, :any
state :turns, :players

player do
  state :hand, :cards, :any
  state :choice, :cards, 1..4
  state :up, :number
  state :pass, :flag, 1, false

  rule(:choose_from_hand) do
    pass = false
    choice.value = choose(:hand, 1..4) {|cards| validate_choice(cards) }
    pass = true if choice.nil?
  end

  rule(:is_up?) do
    up.is_not 0
  end

  rule(:validate_choice) do |cards|
    same_number_of cards
    next true if tableau.count == 0
    same_count_of cards
    greater_than cards
    true
  end

  rule(:same_number_of) do |cards|
    validate_error cards if cards.count > 1 && cards.any? {|c| cards[0].number != c.number }
  end

  rule(:same_count_of) do |cards|
    validate_error cards unless tableau.count == cards.count
  end

  rule(:greater_than) do |cards|
    num = cards[0].number
    num = 14 if num == 1
    num = 15 if num == 0
    tableau_num = tableau[0].number
    tableau_num = 14 if tableau_num == 1
    tableau_num = 15 if tableau_num == 0
    validate_error cards if num <= tableau_num
  end
end

rule(:put_player_choice_on_tableau) do |player|
  used << tableau
  self.tableau = player.choice.value
end

rule(:turn_break?) do |player|
  players.except(player).all? {|u| puts "#{u.name}: #{u.pass.value}"; u.pass.value }
end

rule(:last_one_player?) do
  players.select(:is_up?).count == (players.count - 1)
end

rule(:clear_tableau) do
  tableau.clear
end

progression do
  deck.shuffle
  deck.deal(players) do |player, card|
    player.hand << card
  end

  players.each do |player|
    player.hand.sort
  end

  turns.cycle do |player|
    skip if player.is_up?
    player.choose_from_hand
    put_player_choice_on_tableau(player)
    turn_break?(player) do
      clear_tableau
      end_of_game if last_one_player?
    end
  end
end
