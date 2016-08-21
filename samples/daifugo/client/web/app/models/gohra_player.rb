class GohraPlayer < Gohra::Player
  def initialize(websocket, name)
    super(name)
  end

  def input_choice(state, range)
    sleep 10
    # choice = []
    # range.to_a.each do |i|
    #   websocket.send("[#{@name}] #{i}番目のカード"
    #   card = gets.chomp
    #   break if card.empty?
    #   choice << card.to_i
    # end
    # choice
  end

  def before_choose(state)
    websocket.send("message: あなたの番です。カードを選んでください。")
  end

  def notify_player_choosed(player)
    unless player.choice.empty?
      websocket.send("update:  table")
    else
      websocket.send("message: #{player.name}がパスしました。")
    end
  end

  def handle_validation_error(err, rule)
    websocket.send("message: バリデーションエラー： #{rule.name}") unless rule.name == :validation_choice
  end

  after_rule :turn_break? do |params|
    if params[:result]
      websocket.send("message: 全員パスしました。場札がクリアされます。")
    end
  end
end
