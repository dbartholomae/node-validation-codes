((modules, factory) ->
# Use define if amd compatible define function is defined
  if typeof define is 'function' && define.amd
    define modules, factory
# Use node require if not
  else
    module.exports = factory (require m for m in modules)...
)( ['./Rule'], (ValidatorRule) ->
  # A rule that changes its child rule's violation codes
  # @author Daniel Bartholomae
  class ViolationCodeModifierValidatorRule extends ValidatorRule
    # Create a new ViolationCodeModifierValidatorRule
    #
    # @overload new ViolationCodeModifierValidatorRule(rule, violationCodeModifierFunction, options)
    #   Creates a new ViolationCodeModifierValidatorRule that calls the violationCodeModifierFunction
    #   for each ViolationCode (String) to get the modified ViolationCode (String) to return
    #   @param [ViolationRule] rule The rule to be modified
    #   @param [Function] violationCodeModifierFunction The function to modify ViolationCodes
    #   @param [Object] (options) An optional list of options
    #
    # @overload new ViolationCodeModifierValidatorRule(rule, violationCodeModifierFunction, options)
    #   Creates a new ViolationCodeModifierValidatorRule that prefixes the violationCodePrefix to all
    #   ViolationCodes of its child rule
    #   @param [ViolationRule] rule The rule to be modified
    #   @param [String] violationCodePrefix A string to be prefixed to the child rule's violation codes
    #   @param [Object] (options) An optional list of options
    constructor: (@rule, violationCodeModifierFunction, options) ->
      if typeof violationCodeModifierFunction is 'string'
        violationCodeModifierFunction =
          do (violationCodeModifierFunction) ->
            (code) -> violationCodeModifierFunction + code
      @violationCodeModifierFunction = violationCodeModifierFunction
      super options

    # Set the options for this and all its child rules
    #
    # @param [Object] (options) The options to be set
    setOptions: (options) ->
      @rule.setOptions options
      super

    # Return all possible violation codes for this rule.
    # @return [Array<String>] An array of all possible violation codes for this rule.
    getViolationCodes: ->
      @rule.getViolationCodes().map @violationCodeModifierFunction

    # Validate that a string is a password
    #
    # @param [Object] value The string to validate
    # @return [Array<String>] [] if the string is valid, an Array of all rule violation codes if not
    validate: (value) ->
      @rule.validate(value).map @violationCodeModifierFunction
)