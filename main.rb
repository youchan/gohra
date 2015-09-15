require_relative "rule_engine"

rule = open("samples/daifugo/rule.rb").read

rule_engin = RuleEngine.new(rule, [ User.new("user1"), User.new("user2") ])

rule_engin.run
