require "slack-ruby-client"
require "slack-ruby-bot"
require "eventmachine"

require_relative "./todo_list"

SLACK_API_TOKEN = "xoxb-713852449664-717334255015-Edok9X8YdGzBQbM5f9z0bJit"

Slack.configure do |config|
  config.token = SLACK_API_TOKEN
end

class TimerCommand < SlackRubyBot::Commands::Base
  PATTERN = /タイマー\s*(\d+)(秒|分|時間)/
  help do
    title "タイマー"
    desc "タイマーを設定する"
  end

  command PATTERN

  def self.call(client, data, match)
    _, value, unit = PATTERN.match(match[:command]).to_a
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
            return
          end

    EM.defer do
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

EM.run do
  bot = SlackRubyBot::Server.new(token: SLACK_API_TOKEN, aliases: ["黒猫さん"])
  bot.start_async
end
