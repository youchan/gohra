require_relative "../../lib/gohra/rule_engine"
require_relative "client/console/player"
require_relative "client/slack/slack_interface"
require_relative "client/slack/player"

rule = open("rule.rb").read

rule_engin = RuleEngine.new(rule, [ ConsolePlayer.new("player1"), ConsolePlayer.new("player2"), ConsolePlayer.new("player3") ])

# slack_interface = SlackInterface.new 'daifugo'
# rule_engin = RuleEngine.new(rule, slack_interface.player.map {|su| SlackPlayer.new(su) })

rule_engin.run
