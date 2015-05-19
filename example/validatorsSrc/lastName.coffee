define ['lib/ValidatorRules'], (Rules) ->
  new Rules.ViolationCodeModifier(new Rules.MaxLength(), 'LastName')