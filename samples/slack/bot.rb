require "slack-ruby-bot"
require "eventmachine"

class PongBot < SlackRubyBot::Bot
  command 'timer', /タイマー\s*(\d+)(秒|分|時間)/ do |client, data, match|
    _, value, unit = /タイマー\s*(\d+)(秒|分|時間)/.match(match[:command]).to_a
    value = value.to_i

    sec = case unit
          when "秒"
            value
          when "分"
            value * 60
          when "時間"
            value * 60 * 60
          else
            client.say(text: "タイマーの設定に失敗したのじゃ。", channel: data.channel)
            next
          end

    Thread.start do
      sleep(sec)
      client.say(text: "#{value}#{unit}経ったのじゃ。", channel: data.channel)
    end

    client.say(text: "タイマーを#{value}#{unit}にセットしたのじゃ。", channel: data.channel)
  end
end

class Dice < SlackRubyBot::Commands::Base
  help do
    title "サイコロ"
    desc "サイコロを振る"
  end

  command "サイコロ"

  def self.call(client, data, match)
    client.say(text: "サイコロの目は#{rand(6)}じゃ。", channel: data.channel)
  end
end

PongBot.run
