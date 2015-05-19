((modules, factory) ->
# Use define if amd compatible define function is defined
  if typeof define is 'function' && define.amd
    define modules, factory
# Use node require if not
  else
    module.exports = factory (require m for m in modules)...
)( ['./Rule'], (ValidatorRule) ->
  # A rule to validate that a value matches a regex
  # @author Daniel Bartholomae
  class RegexValidatorRule extends ValidatorRule
    # Create a new RegexValidatorRule. As default it uses /(?:)/
    #
    # @param [Regex] regex The regular expression to use
    constructor: (options) ->
      @options =
        regex: /(?:)/
      super options

    # Return all possible violation codes for this rule.
    # @return [Array<String>] An array of all possible violation codes for this rule.
    getViolationCodes: -> ['RegexMismatch']

    # Validate that a String is either undefined or matches this.regex
    # When the regex is not matched the method returns this.getViolationCodes(),
    # which can be used when inheriting from this class.
    #
    # @param [String] str The string to validate
    # @return [Array<String>] [] if the string is valid or undefined, ['RegexMismatch'] if it does not match this.regex
    validate: (str) ->
      return [] if !str?
      return @getViolationCodes() unless @options.regex.test str
      return []
)