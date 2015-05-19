((modules, factory) ->
# Use define if amd compatible define function is defined
  if typeof define is 'function' && define.amd
    define modules, factory
# Use node require if not
  else
    module.exports = factory (require m for m in modules)...
)( ['./Regex'], (RegexValidatorRule) ->
  # A rule to validate that a value is an email address
  # @author Daniel Bartholomae
  class EmailValidatorRule extends RegexValidatorRule
    # Create a new EmailValidatorRule. As a default it uses the W3C recommendation
    # ^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$
    # Please note that this requirement is a willful violation of RFC 5322, both accepting some addresses
    # that would be invalid under RFC 5322, as well as rejecting some addresses that are valid within RFC 5322.
    #
    # @param [Object] (options) An optional list of options
    # @option options [RegEx] regex A regular expression
    constructor: (options) ->
      options ?= {}
      options?.regex ?=
        ///
          ^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+
          @
          [a-zA-Z0-9]
          (?:[a-zA-Z0-9-]{0,61}
           [a-zA-Z0-9]
          )?
          (?:\.
           [a-zA-Z0-9]
           (?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?
          )*$
        ///

      super options

    # Return all possible violation codes for this rule.
    # @return [Array<String>] An array of all possible violation codes for this rule.
    getViolationCodes: -> ['NotAnEmail']
)