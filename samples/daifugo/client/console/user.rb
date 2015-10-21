class ConsoleUser < User
  def choose(state_id, range)
    state = self.state(state_id)
    p state
    cards = nil
    while cards.nil?
      choice = []
      range.to_a.each do |i|
        print "#{i}番目のカード"
        card = gets.chomp
        break if card.empty?
        choice << card.to_i
      end
      return nil if choice.empty?
      if block_given?
        cards = state.select(choice, &proc)
      else
        cards = state.select(choice)
      end
    end

    cards
  end
end
