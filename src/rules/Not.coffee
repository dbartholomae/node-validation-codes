((modules, factory) ->
# Use define if amd compatible define function is defined
  if typeof define is 'function' && define.amd
    define modules, factory
# Use node require if not
  else
    module.exports = factory (require m for m in modules)...
)( ['./Rule'], (ValidatorRule) ->
  # A rule to validate that an input field does not satisfy a rule
  # @author Daniel Bartholomae
  class NotValidatorRule extends ValidatorRule
    # Create a new NotValidatorRule
    #
    # @param [ValidatorRule] rule The rule that should be negated
    # @param [Object] (options) An optional list of options
    constructor: (@rule, options) ->
      super options

    # Set the options for this and all its child rules
    #
    # @param [Object] (options) The options to be set
    setOptions: (options) ->
      @rule.setOptions options
      super

    # Return all possible violation codes for this rule.
    # @return [Array<String>] An array of all possible violation codes for this rule.
    getViolationCodes: -> 'Not' + violationCode for violationCode in @rule.getViolationCodes()

    # Validate that a value does not satisfy a rule
    #
    # @param [Object] value The value to validate
    # @return [Array<String>] [] if the value is valid, 'Not' + the violation codes of the negated rule if it isn't
    validate: (value) -> if @rule.isValid(value) then @getViolationCodes() else []
)