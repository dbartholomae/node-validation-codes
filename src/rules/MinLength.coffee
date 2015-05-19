((modules, factory) ->
# Use define if amd compatible define function is defined
  if typeof define is 'function' && define.amd
    define modules, factory
# Use node require if not
  else
    module.exports = factory (require m for m in modules)...
)( ['./Rule'], (ValidatorRule) ->
  # A rule to validate that a value has a minimum length
  # @author Daniel Bartholomae
  class MinLengthValidatorRule extends ValidatorRule
    # Create a new MinLengthValidatorRule
    #
    # @param [Object] (options) An optional list of options
    # @option options [Number] minLength Minimum length. Default: 6
    constructor: (options) ->
      @options =
        minLength: 6

      super

    # Return all possible violation codes for this rule.
    # @return [Array<String>] An array of all possible violation codes for this rule.
    getViolationCodes: -> ['TooShort']

    # Validate that a String is either undefined or at least options.minFieldLength long
    #
    # @param [String] str The string to validate
    # @return [Array<String>] [] if the string is valid or undefined, ['TooShort'] if it is too short
    validate: (str) ->
      return [] if !str?
      return ['TooShort'] if str.length < @options.minLength
      return []
)