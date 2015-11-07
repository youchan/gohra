class ConsolePlayer < Player
  def input_choice(state, range)
    choice = []
    range.to_a.each do |i|
      print "[#{@name}] #{i}番目のカード"
      card = gets.chomp
      break if card.empty?
      choice << card.to_i
    end
    choice
  end

  def before_choose(state)
    puts "[#{@name}] あなたの番です。カードを選んでください。"
    state.value.each_with_index do |v, i|
      print "#{i}:[#{v}]"
    end
    puts
  end

  def notify_player_choosed(player)
    unless player.choice.empty?
      puts "[#{@name}] #{player.name}が#{player.choice}を切りました。"
    else
      puts "[#{@name}] #{player.name}がパスしました。"
    end
  end

  def handle_validation_error(err, rule)
    puts "バリデーションエラー： #{rule.name}" unless rule.name == :validation_choice
  end

  after_rule :turn_break? do |params|
    if params[:result]
      puts "全員パスしました。場札がクリアされます。"
    end
  end
end
