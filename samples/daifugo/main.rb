require_relative "../../lib/gohra/rule_engine"
require_relative "client/console/user"

rule = open("rule.rb").read

rule_engin = RuleEngine.new(rule, [ ConsoleUser.new("user1"), ConsoleUser.new("user2"), ConsoleUser.new("user3") ])

rule_engin.run
