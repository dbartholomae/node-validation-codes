expect = require('chai').expect

requirejs = require 'requirejs'
requirejs.config
  baseUrl: 'lib'
Validator = require "../lib/ValidatorRules"

describe "A Validator", ->
  it "can be required via requirejs", (done) ->
    requirejs ['ValidatorRules'], (ValidatorLoaded) ->
      expect(ValidatorLoaded).to.exist
      done()

  for rule in ['And', 'Blacklist', 'Email', 'Existence', 'MaxLength', 'MinLength', 'Not', 'Or', 'Regex', 'Rule',
               'Object', 'ViolationCodeModifier']
    it "exposes the " + rule + " rule", ->
      expect(Validator[rule]).to.exist

describe "A ValidationRule", ->
  validationRule = null

  beforeEach ->
    validationRule = new Validator.Rule()

  it "accepts a set of options", ->
    options = {
      'optionA': 'valueA'
      'optionB': 'valueB'
    }
    validationRule = new Validator.Rule(options)
    expect(validationRule.options).to.deep.equal options

  it "allows to set options", ->
    options = {
      'optionA': 'valueA'
      'optionB': 'valueB'
    }
    validationRule.setOptions options
    expect(validationRule.options).to.deep.equal options

  it "allows to overwrite options", ->
    optionsAtConstruction = {
      'optionA': 'valueA'
      'optionB': 'valueB'
    }
    validationRule = new Validator.Rule(optionsAtConstruction)
    optionsAdded = {
      'optionB': 'newValueB'
      'optionC': 'valueC'
    }
    validationRule.setOptions optionsAdded

    optionsExpected = {
      'optionA': 'valueA'
      'optionB': 'newValueB'
      'optionC': 'valueC'
    }

    expect(validationRule.options).to.deep.equal optionsExpected

describe "An AndValidationRule", ->
  rules = null
  andValidator = null

  beforeEach ->
    rules = [new Validator.Rule(), new Validator.Rule(), new Validator.Rule(), new Validator.Rule()]
    rules[0].getViolationCodes = -> ['A', 'B']
    rules[1].getViolationCodes = -> ['B', 'C']
    rules[2].getViolationCodes = -> ['C', 'D']
    rules[3].getViolationCodes = -> ['D', 'A']
    andValidator = new Validator.And rules

  it "accepts an array of rules", ->
    expect(andValidator.rules).to.equal rules

  it "relays options in setOptions to all its child rules", ->
    options = {
      'optionA': 'valueA'
      'optionB': 'valueB'
    }
    andValidator.setOptions options
    for rule in andValidator.rules
      expect(rule.options).to.deep.equal options

  it "returns the union of all of its rules ViolationCodes", ->
    expectedResult = ['A', 'B', 'C', 'D']
    expect(andValidator.getViolationCodes().sort()).to.deep.equal expectedResult

  it "validates a value that is validated by all of its rules", ->
    expect(andValidator.validate("")).to.deep.equal []
    expect(andValidator.isValid("")).to.be.true

  it "does not validate a value that is not validated by one of its rules", ->
    rules[1].getViolationCodes = -> ['wrong']
    rules[1].validate = -> ['wrong']
    expect(andValidator.validate("")).to.deep.equal ['wrong']
    expect(andValidator.isValid("")).to.be.false

  it "returns the violation codes of all its rules that are violated by a value", ->
    rules[1].validate = -> ['B']
    rules[2].validate = -> ['C', 'D']
    rules[3].validate = -> ['D']
    expectedResult = ['B','C','D']
    expect(andValidator.validate("").sort()).to.deep.equal expectedResult


describe "A BlacklistValidationRule", ->
  it "has an empty blacklist as default", ->
    blacklistValidationRule = new Validator.Blacklist()
    expect(blacklistValidationRule.options.blacklist).to.deep.equal []

  describe "that has a blacklist", ->
    options = null
    blacklistValidationRule = null

    beforeEach ->
      options = {
        blacklist: ['A', 'B']
      }
      blacklistValidationRule = new Validator.Blacklist(options)

    it "accepts a blacklist as an option", ->
      expect(blacklistValidationRule.options.blacklist).to.deep.equal options.blacklist

    it "accepts values that are not on the blacklist", ->
      expect(blacklistValidationRule.validate('C')).to.deep.equal []
      expect(blacklistValidationRule.isValid('C')).to.be.true

    it "does not accept values that are on the blacklist", ->
      expect(blacklistValidationRule.validate('A')).to.deep.equal ['Blacklisted']
      expect(blacklistValidationRule.isValid('A')).to.be.false
      expect(blacklistValidationRule.validate('B')).to.deep.equal ['Blacklisted']
      expect(blacklistValidationRule.isValid('B')).to.be.false


describe "An EmailValidationRule", ->
  emailValidationRule = null
  beforeEach ->
    emailValidationRule = new Validator.Email()

  it "uses the W3C recommended regex for checking emails by default", ->
    expect(emailValidationRule.options.regex).to.deep.equal(
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
    )

  it "accepts other regex as an option", ->
    options =
      regex: /a-z/
    emailValidationRule = new Validator.Email(options)
    expect(emailValidationRule.options.regex).to.deep.equal options.regex

  validEmails = ['edwde@wde', 'ab@dde.com', 'daw@ded.sde.de.dew.de', 'wekw+delk@dwe.cd']
  for email in validEmails
    ((email) ->
      it "should validate email " + email, ->
        expect(emailValidationRule.validate(email) ).to.deep.equal []
        expect(emailValidationRule.isValid(email)).to.be.true
    )(email)

  invalidEmails = ['@google.com', ' info@gmail.com ']
  for email in invalidEmails
    ((email) ->
      it "should not validate email " + email, ->
        expect(emailValidationRule.validate(email)).to.deep.equal ['NotAnEmail']
        expect(emailValidationRule.isValid(email)).to.be.false
    )(email)

describe "An ExistenceValidationRule", ->
  existenceValidationRule = null
  beforeEach ->
    existenceValidationRule = new Validator.Existence()

  definedValues = [{}, [], "", 0, "Test"]
  for value in definedValues
    do (value) ->
      it "validates defined value " + value, ->
        expect(existenceValidationRule.validate value).to.deep.equal []
        expect(existenceValidationRule.isValid value).to.be.true

  undefinedValues = [undefined, null]
  for value in undefinedValues
    do (value) ->
      it "does not validate undefined value " + value, ->
        expect(existenceValidationRule.validate value).to.deep.equal ['Missing']
        expect(existenceValidationRule.isValid value).to.be.false


describe "A MaxLengthValidationRule", ->
  maxLengthValidationRule = null
  beforeEach ->
    maxLengthValidationRule = new Validator.MaxLength()

  it "uses a maximum length of 100 by default", ->
    expect(maxLengthValidationRule.options.maxLength).to.equal 100

  it "accepts other maximum lengths as an option", ->
    options =
      maxLength: 20
    maxLengthValidationRule = new Validator.MaxLength options
    expect(maxLengthValidationRule.options.maxLength).to.deep.equal options.maxLength

  it "validates undefined values", ->
    str = undefined
    expect(maxLengthValidationRule.validate(str) ).to.deep.equal []
    expect(maxLengthValidationRule.isValid(str)).to.be.true

    str = null
    expect(maxLengthValidationRule.validate(str) ).to.deep.equal []
    expect(maxLengthValidationRule.isValid(str)).to.be.true

  validStrings = ['', "test", "1köfdse##defaü+refkoöKÖL",
                  "123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 "]
  for str in validStrings
    do (str) ->
      it "validates string " + str, ->
        expect(maxLengthValidationRule.validate(str) ).to.deep.equal []
        expect(maxLengthValidationRule.isValid(str)).to.be.true

  invalidStrings = ["123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 1",
                    "123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 12"]
  for str in invalidStrings
    do (str) ->
      it "does not validate string " + str, ->
        expect(maxLengthValidationRule.validate(str) ).to.deep.equal ['TooLong']
        expect(maxLengthValidationRule.isValid(str)).to.be.false


describe "A MinLengthValidationRule", ->
  minLengthValidationRule = null
  beforeEach ->
    minLengthValidationRule = new Validator.MinLength()

  it "uses a min length of 6 by default", ->
    expect(minLengthValidationRule.options.minLength).to.equal 6

  it "accepts other maximum lengths as an option", ->
    options =
      minLength: 20
    minLengthValidationRule = new Validator.MinLength options
    expect(minLengthValidationRule.options.minLength).to.deep.equal options.minLength

  it "validates undefined values", ->
    str = undefined
    expect(minLengthValidationRule.validate(str) ).to.deep.equal []
    expect(minLengthValidationRule.isValid(str)).to.be.true

    str = null
    expect(minLengthValidationRule.validate(str) ).to.deep.equal []
    expect(minLengthValidationRule.isValid(str)).to.be.true

  validStrings = ["123456", "abcdef", "abcdefgtrgr", "      ",
                  "123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 "]
  for str in validStrings
    do (str) ->
      it "validates string " + str, ->
        expect(minLengthValidationRule.validate(str) ).to.deep.equal []
        expect(minLengthValidationRule.isValid(str)).to.be.true

  invalidStrings = ["", "1", "12", "123", "1234", "12345", "     "]
  for str in invalidStrings
    do (str) ->
      it "does not validate string " + str, ->
        expect(minLengthValidationRule.validate(str) ).to.deep.equal ['TooShort']
        expect(minLengthValidationRule.isValid(str)).to.be.false

describe "A NotValidationRule", ->
  rule = null
  notValidator = null

  beforeEach ->
    rule = new Validator.Rule()
    rule.getViolationCodes = -> ['A', 'B']
    notValidator = new Validator.Not rule

  it "accepts a rule", ->
    expect(notValidator.rule).to.equal rule

  it "relays options in setOptions to its child rule", ->
    options = {
      'optionA': 'valueA'
      'optionB': 'valueB'
    }
    notValidator.setOptions options
    expect(notValidator.rule.options).to.deep.equal options

  it "returns the ViolationCodes of its rule with 'Not' prepended", ->
    expectedResult = ['NotA', 'NotB']
    expect(notValidator.getViolationCodes().sort()).to.deep.equal expectedResult

  it "validates a value that is not validated by its rule", ->
    rule.getViolationCodes = -> ['Wrong']
    rule.validate = -> ['Wrong']
    expect(notValidator.validate("")).to.deep.equal []
    expect(notValidator.isValid("")).to.be.true

  it "does not validate a value that is validated by its rule", ->
    rule.getViolationCodes = -> ['Wrong']
    rule.validate = -> []
    expect(notValidator.validate("")).to.deep.equal ['NotWrong']
    expect(notValidator.isValid("")).to.be.false

describe "A RegexValidationRule", ->
  regex = /[a-z]/
  regexValidationRule = null

  beforeEach ->
    options =
      regex: regex
    regexValidationRule = new Validator.Regex options

  it "uses /(?:)/ as default regex", ->
    regexValidationRule = new Validator.Regex()
    expect(regexValidationRule.options.regex).to.deep.equal /(?:)/

  it "accepts other regex as an option", ->
    expect(regexValidationRule.options.regex).to.equal regex

  validStrings = ["a", "b", "z", "avds", "KJLDSAaD"]
  for str in validStrings
    do (str) ->
      it "validates strings " + str + " that matches its regex " + regex, ->
        expect(regexValidationRule.validate(str) ).to.deep.equal []
        expect(regexValidationRule.isValid(str)).to.be.true

  invalidStrings = ["", "1", "12", "AB", "X", "12345", " "]
  for str in invalidStrings
    do (str) ->
      it "does not validate string " + str + " that does not match its regex " + regex, ->
        expect(regexValidationRule.validate(str) ).to.deep.equal ['RegexMismatch']
        expect(regexValidationRule.isValid(str)).to.be.false


describe "An OrValidationRule", ->
  rules = null
  orValidator = null

  beforeEach ->
    rules = [new Validator.Rule(), new Validator.Rule(), new Validator.Rule(), new Validator.Rule()]
    rules[0].getViolationCodes = -> ['A', 'B']
    rules[1].getViolationCodes = -> ['B', 'C']
    rules[2].getViolationCodes = -> ['C', 'D']
    rules[3].getViolationCodes = -> ['D', 'A']
    orValidator = new Validator.Or rules

  it "accepts an array of rules", ->
    expect(orValidator.rules).to.equal rules

  it "relays options in setOptions to all its child rules", ->
    options = {
      'optionA': 'valueA'
      'optionB': 'valueB'
    }
    orValidator.setOptions options
    for rule in orValidator.rules
      expect(rule.options).to.deep.equal options

  it "returns the union of all of its rules ViolationCodes", ->
    expectedResult = ['A', 'B', 'C', 'D']
    expect(orValidator.getViolationCodes().sort()).to.deep.equal expectedResult

  it "validates a value that is validated by one of its rules", ->
    rules[1].getViolationCodes = -> ['wrong']
    rules[1].validate = -> ['wrong']
    expect(orValidator.validate("")).to.deep.equal []
    expect(orValidator.isValid("")).to.be.true

  it "does not validate a value that is not validated by one of its rules", ->
    for rule in rules
      rule.getViolationCodes = -> ['wrong']
      rule.validate = -> ['wrong']
    expect(orValidator.validate("")).to.deep.equal ['wrong']
    expect(orValidator.isValid("")).to.be.false

  it "returns the violation codes of all its rules that are violated by a value", ->
    rules[0].validate = -> ['B']
    rules[1].validate = -> ['B']
    rules[2].validate = -> ['C', 'D']
    rules[3].validate = -> ['D']
    expectedResult = ['B','C','D']
    expect(orValidator.validate("").sort()).to.deep.equal expectedResult

describe "An ObjectValidationRule", ->
  rules = null
  objectValidator = null

  describe "when setting up", ->
    beforeEach ->
      rules =
        a: new Validator.Rule()
        b: new Validator.Rule()
        c: new Validator.Rule()
        d: new Validator.Rule()
      rules.a.getViolationCodes = -> ['A', 'B']
      rules.b.getViolationCodes = -> ['B', 'C']
      rules.c.getViolationCodes = -> ['C', 'D']
      rules.d.getViolationCodes = -> ['D', 'A']
      objectValidator = new Validator.Object rules

    it "accepts an object with rules", ->
      expect(objectValidator.rules).to.equal rules

    it "relays options in setOptions to all its child rules", ->
      options = {
        'optionA': 'valueA'
        'optionB': 'valueB'
      }
      objectValidator.setOptions options
      for rule in objectValidator.rules
        expect(rule.options).to.deep.equal options

    it "returns the union of all of its rules ViolationCodes", ->
      expectedResult = ['A', 'B', 'C', 'D']
      expect(objectValidator.getViolationCodes().sort()).to.deep.equal expectedResult

    it "validates an undefined object", ->
      expect(objectValidator.validate(undefined)).to.deep.equal []
      expect(objectValidator.isValid(undefined)).to.be.true
      expect(objectValidator.validate(null)).to.deep.equal []
      expect(objectValidator.isValid(null)).to.be.true

  describe "when validating objects", ->
    beforeEach ->
      rules =
        a: new Validator.Rule()
        b: new Validator.Rule()
        c: new Validator.Rule()
        d: new Validator.Rule()
      rules.a.getViolationCodes = -> ['A', 'B']
      rules.a.validate = (val) -> if val? then [] else ['A','B']
      rules.b.getViolationCodes = -> ['B', 'C']
      rules.b.validate = (val) -> if val? then [] else ['B','C']
      rules.c.getViolationCodes = -> ['C', 'D']
      rules.c.validate = (val) -> if val? then [] else ['C','D']
      rules.d.getViolationCodes = -> ['D', 'A']
      rules.d.validate = (val) -> if val? then [] else ['D','A']
      objectValidator = new Validator.Object rules

    it "validates an object who's properties are validated by the corresponding rules", ->
      obj =
        a: ""
        b: ""
        c: ""
        d: ""
      expect(objectValidator.validate(obj)).to.deep.equal []
      expect(objectValidator.isValid(obj)).to.be.true

    it "does not validate a value that is not validated by one of its rules", ->
      obj =
        a: ""
        b: undefined
        c: ""
        d: ""
      expect(objectValidator.validate(obj)).to.deep.equal ['B', 'C']
      expect(objectValidator.isValid(obj)).to.be.false

    it "returns the violation codes of all its rules that are violated by a value", ->
      obj =
        a: ""
        b: undefined
        c: undefined
        d: ""
      expectedResult = ['B','C','D']
      expect(objectValidator.validate(obj).sort()).to.deep.equal expectedResult

describe "A ViolationCodeModifierValidationRule", ->
  rule = null
  violationCodeModifierValidator = null

  beforeEach ->
    rule = new Validator.Rule()
    rule.getViolationCodes = -> ['A', 'B']
    violationCodeModifierValidator = new Validator.ViolationCodeModifier rule, "mod"

  it "accepts a rule", ->
    expect(violationCodeModifierValidator.rule).to.equal rule

  it "relays options in setOptions to its child rule", ->
    options = {
      'optionA': 'valueA'
      'optionB': 'valueB'
    }
    violationCodeModifierValidator.setOptions options
    expect(violationCodeModifierValidator.rule.options).to.deep.equal options

  it "validates a value that is validated by its rule", ->
    expect(violationCodeModifierValidator.validate("")).to.deep.equal []
    expect(violationCodeModifierValidator.isValid("")).to.be.true

  describe "with a ViolationCodeModifier string", ->
    it "returns the ViolationCodes of its rule with the ViolationCodeModifier string prepended", ->
      expectedResult = ['modA', 'modB']
      expect(violationCodeModifierValidator.getViolationCodes().sort()).to.deep.equal expectedResult

    it "does not validate a value that is not validated by its rule", ->
      rule.getViolationCodes = -> ['Wrong']
      rule.validate = -> ['A']
      expect(violationCodeModifierValidator.validate("")).to.deep.equal ['modA']
      expect(violationCodeModifierValidator.isValid("")).to.be.false
