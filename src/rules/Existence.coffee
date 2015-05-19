((modules, factory) ->
# Use define if amd compatible define function is defined
  if typeof define is 'function' && define.amd
    define modules, factory
# Use node require if not
  else
    module.exports = factory (require m for m in modules)...
)( ['./Rule'], (ValidatorRule) ->
  # A rule to validate that a value is not undefined
  # @author Daniel Bartholomae
  class ExistenceValidatorRule extends ValidatorRule

    # Return all possible violation codes for this rule.
    # @return [Array<String>] An array of all possible violation codes for this rule.
    getViolationCodes: -> ['Missing']

    # Validate that a value is not undefined
    #
    # @param [String] value The value to validate
    # @return [Array<String>] [] if the value is valid , ['Missing'] if it is undefined
    validate: (value) ->
      return ['Missing'] if !value?
      return []
)