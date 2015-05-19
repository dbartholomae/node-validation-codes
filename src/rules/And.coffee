((modules, factory) ->
# Use define if amd compatible define function is defined
  if typeof define is 'function' && define.amd
    define modules, factory
# Use node require if not
  else
    module.exports = factory (require m for m in modules)...
)( ['./Rule'], (ValidatorRule) ->
  # A rule to validate that a value satisfies all of multiple rules
  # @author Daniel Bartholomae
  class AndValidatorRule extends ValidatorRule
    union = (arrays...) ->
      result = []
      for arr in arrays
        if arr? and arr.length > 0
          for el in arr
            if !(el in result)
              result.push el
      return result

    # Set the options for this and all its child rules
    #
    # @param [Object] (options) The options to be set
    setOptions: (options) ->
      for rule in @rules
        rule.setOptions options
      super

    # Create a new AndValidatorRule
    #
    # @param [Array<ValidatorRule>] rules An array of rules that should be checked
    # @param [Object] (options) An optional list of options
    constructor: (@rules, options) ->
      super options


    # Return all possible violation codes for this rule.
    # @return [Array<String>] An array of all possible violation codes for this rule.
    getViolationCodes: -> union (rule.getViolationCodes() for rule in @rules)...

    # Validate that a field satisfies all rules given.
    #
    # @param [Object] value The value to validate
    # @return [Array<String>] [] if the string is valid, an Array of all rule violation codes if not
    validate: (value) -> union (rule.validate(value) for rule in @rules)...
)