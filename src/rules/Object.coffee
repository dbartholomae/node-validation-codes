((modules, factory) ->
# Use define if amd compatible define function is defined
  if typeof define is 'function' && define.amd
    define modules, factory
# Use node require if not
  else
    module.exports = factory (require m for m in modules)...
)( ['./Rule'], (ValidatorRule) ->
  # A rule to validate that the properties of an object fullfill certain rules.
  # @author Daniel Bartholomae
  class ObjectValidatorRule extends ValidatorRule
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
      for key, rule of @rules
        rule.setOptions options
      super

    # Create a new ObjectValidatorRule
    #
    # @example Account check
    #   new ObjectValidatorRule(
    #     email: new AndRule [new ExistenceRule(), new EmailValidatorRule()]
    #     password: new AndRule [new ExistenceRule(), new MinLengthRule()]
    #   )
    #
    # @param [Object] rules An object that gives the rule for each property of the input object to be checked
    # @param [Object] (options) An optional list of options
    constructor: (@rules, options) ->
      super options

    # Return all possible violation codes for this rule.
    # @return [Array<String>] An array of all possible violation codes for this rule.
    getViolationCodes: -> union (rule.getViolationCodes() for key, rule of @rules)...

    # Validate that an object satisfies all rules given.
    #
    # @param [Object] obj The object to validate
    # @return [Array<String>] [] if the object is valid or undefined, an Array of all rule violation codes otherwise
    validate: (obj) ->
      return [] unless obj?
      union (rule.validate(obj[key]) for key, rule of @rules)...
)