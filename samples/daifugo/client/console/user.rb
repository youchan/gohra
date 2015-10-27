class ConsoleUser < User
  def input_choice(state, range)
    choice = []
    range.to_a.each do |i|
      print "#{i}番目のカード"
      card = gets.chomp
      break if card.empty?
      choice << card.to_i
    end
    choice
  end

  def before_choose(state)
    puts "#{@name}の番です。カードを選んでください。"
    state.value.each_with_index do |v, i|
      print "[#{v}]=>#{i} "
    end
    puts
  end

  def notice(type, params: {})
    case type
    when :update_field
      puts "#{params[:user].name}が#{params[:cards]}を切りました。"
    else
      puts type.to_s
    end
  end
end
