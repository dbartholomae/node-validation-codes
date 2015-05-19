define ['lib/ValidatorRules'], (Rules) ->
  new Rules.ViolationCodeModifier(new Rules.And([new Rules.Existence(), new Rules.Blacklist(),
                                        new Rules.MinLength(), new Rules.MaxLength()]), 'Password')