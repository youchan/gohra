require_relative "../../lib/gohra/rule_engine"
#require_relative "client/console/user"
require_relative "client/slack/slack_interface"
require_relative "client/slack/user"

rule = open("rule.rb").read

#rule_engin = RuleEngine.new(rule, [ ConsoleUser.new("user1"), ConsoleUser.new("user2"), ConsoleUser.new("user3") ])

slack_interface = SlackInterface.new 'daifugo'
rule_engin = RuleEngine.new(rule, slack_interface.users.map {|su| SlackUser.new(su) })

rule_engin.run
