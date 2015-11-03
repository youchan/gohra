require_relative 'slack_interface'

class SlackUser < User
  def initialize(slack)
    @slack = slack
  end

  def input_choice(state, range)
    choice = []
    range.to_a.each do |i|
      @slack.puts "#{i}番目のカード"
      card = gets.chomp
      break if card.empty?
      choice << card.to_i
    end
    choice
  end

  def before_choose(state)
    @slack.puts "あなたの番です。カードを選んでください。"
    message = ""
    state.value.each_with_index do |v, i|
      message << "#{i}=>[#{v}] "
    end
    @slack.puts message
  end

  def notice(type, params: {})
    case type
    when :update_tableau
      unless params[:cards].nil?
        @slack.puts "#{params[:user].name}が#{params[:cards]}を切りました。"
      else
        @slack.puts "#{params[:user].name} がパスしました。"
      end
    else
      @slack.puts "なぞのメッセージ: #{type.to_s}"
    end
  end
end
