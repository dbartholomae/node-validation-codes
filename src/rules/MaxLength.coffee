((modules, factory) ->
# Use define if amd compatible define function is defined
  if typeof define is 'function' && define.amd
    define modules, factory
# Use node require if not
  else
    module.exports = factory (require m for m in modules)...
)( ['./Rule'], (ValidatorRule) ->
  # A rule to validate that a value has a maximum length
  # @author Daniel Bartholomae
  class MaxLengthValidatorRule extends ValidatorRule
    # Create a new MaxLengthValidatorRule
    #
    # @param [Object] (options) An optional list of options
    # @option options [Number] maxLength Maximum length. Default: 100
    constructor: (options) ->
      @options =
        maxLength: 100

      super

    # Return all possible violation codes for this rule.
    # @return [Array<String>] An array of all possible violation codes for this rule.
    getViolationCodes: -> ['TooLong']

    # Validate that a String is either undefined or at most options.maxFieldLength long
    #
    # @param [String] str The string to validate
    # @return [Array<String>] [] if the string is valid or undefined, ['TooLong'] if it is too long
    validate: (str) ->
      return [] if !str?
      return ['TooLong'] if str.length > @options.maxLength
      return []
)