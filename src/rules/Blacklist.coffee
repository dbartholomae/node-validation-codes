((modules, factory) ->
# Use define if amd compatible define function is defined
  if typeof define is 'function' && define.amd
    define modules, factory
# Use node require if not
  else
    module.exports = factory (require m for m in modules)...
)( ['./Rule'], (ValidatorRule) ->
  # A rule to validate that a value is not on a blacklist
  # @author Daniel Bartholomae
  class BlacklistValidatorRule extends ValidatorRule
    # Create a new BlacklistValidatorRule
    #
    # @param [Object] (options) An optional list of options
    # @option options [Array] blacklist List of blacklisted values Default: []
    constructor: (options) ->
      @options =
        blacklist: []
      super

    # Return all possible violation codes for this rule.
    # @return [Array<String>] An array of all possible violation codes for this rule.
    getViolationCodes: -> ['Blacklisted']

    # Validate that a value is not in options.blacklist
    #
    # @param [Object] value The value to validate
    # @return [Array<String>] [] if the value is valid, ['Blacklisted'] if it is in the blacklist
    validate: (value) ->
      return ['Blacklisted'] if value in @options.blacklist
      return []
)