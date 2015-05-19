((modules, factory) ->
# Use define if amd compatible define function is defined
  if typeof define is 'function' && define.amd
    define modules, factory
# Use node require if not
  else
    module.exports = factory (require m for m in modules)...
)( [], ->
  # A rule to validate input fields
  # @author Daniel Bartholomae
  class ValidatorRule
    # Create a new ValidatorRule. When extending this constructor, set this.options to the default values
    # and call super to overwrite all options given as a parameter.
    #
    # @param [Object] (options) An optional list of options
    constructor: (options) ->
      @options ?= {}
      @setOptions options

    # Set the options of this rule.
    #
    # @param [Object] (options) An optional list of options
    setOptions: (options) ->
      if options?
        for own option, value of options
          @options[option] = value

    # Return all possible violation codes for this rule.
    # @return [Array<String>] An array of all possible violation codes for this rule.
    getViolationCodes: -> []

    # Validate an object and return a list of codes for all rules it violates
    #
    # @param [Object] value The value to validate
    # @return [Array<String>] [''] if the string is valid, an array of all rule violation codes if not
    validate: (value) ->
      return []

    # Returns true if a given object is valid
    #
    # @param [Object] value The object to validate
    # @return [Boolean] true if the object is valid, false otherwise
    isValid: (value) -> @validate(value).length == 0
)