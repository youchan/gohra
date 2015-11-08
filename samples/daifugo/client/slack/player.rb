require_relative 'slack_interface'

class SlackPlayer < Player
  def initialize(slack_user)
    super slack_user.name
    @slack_user = slack_user
  end

  def input_choice(state, range)
    begin
      input = @slack_user.input
      return nil if input == 'pass'
      input.split(',').map &:to_i
    rescue
      @slack_user.puts "0,2,3 のようにカンマ区切りで番号を入力してください。"
      retry
    end
  end

  def before_choose(state)
    @slack_user.puts "あなたの番です。カードを選んでください。"
    message = ""
    state.value.each_with_index do |v, i|
      message << "#{i}=>[#{v}] "
    end
    @slack_user.puts message
  end

  def notify_player_choosed(player)
    unless player.choice.empty?
      @slack_user.puts "#{player.name}が#{player.choice}を切りました。"
    else
      @slack_user.puts "#{player.name}がパスしました。"
    end
  end

  def handle_validation_error(err, rule)
    case rule.name
    when :same_number_of
      @slack_user.puts "複数のカードを選ぶ場合は同じ数でなければなりません。"
    when :same_count_of
      @slack_user.puts "場札のカードと同じ枚数を選んでください。"
    when :greater_than
      @slack_user.puts "場札のカードより大きいカードを選んでください。"
    end
  end

  after_rule :turn_break? do |params|
    if params[:result]
      @slack_user.puts "全員パスしました。場札がクリアされます。"
    end
  end
end
