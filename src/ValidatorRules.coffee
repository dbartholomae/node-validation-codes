ruleNames = ['And', 'Blacklist', 'Email', 'Existence', 'MaxLength', 'MinLength', 'Not', 'Or', 'Regex', 'Rule', 'Object',
             'ViolationCodeModifier']
rulePaths = ruleNames.map( (s) -> './rules/' + s)

((modules, factory) ->
  # Use define if amd compatible define function is defined
  if typeof define is 'function' && define.amd
    define modules, factory
  # Use node require if not
  else
    module.exports = factory (require m for m in modules)...
)( rulePaths, (rules...) ->
  result = {}
  for i in [0..ruleNames.length-1]
    result[ruleNames[i]] = rules[i]
  return result
)