define ['lib/ValidatorRules'], (Rules) ->
  new Rules.ViolationCodeModifier(new Rules.And([new Rules.Existence(), new Rules.Blacklist(),
                                                 new Rules.Email(), new Rules.MaxLength()]), 'Email')