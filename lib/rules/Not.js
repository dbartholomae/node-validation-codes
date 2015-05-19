// Generated by CoffeeScript 1.7.1
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  (function(modules, factory) {
    var m;
    if (typeof define === 'function' && define.amd) {
      return define(modules, factory);
    } else {
      return module.exports = factory.apply(null, (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = modules.length; _i < _len; _i++) {
          m = modules[_i];
          _results.push(require(m));
        }
        return _results;
      })());
    }
  })(['./Rule'], function(ValidatorRule) {
    var NotValidatorRule;
    return NotValidatorRule = (function(_super) {
      __extends(NotValidatorRule, _super);

      function NotValidatorRule(rule, options) {
        this.rule = rule;
        NotValidatorRule.__super__.constructor.call(this, options);
      }

      NotValidatorRule.prototype.setOptions = function(options) {
        this.rule.setOptions(options);
        return NotValidatorRule.__super__.setOptions.apply(this, arguments);
      };

      NotValidatorRule.prototype.getViolationCodes = function() {
        var violationCode, _i, _len, _ref, _results;
        _ref = this.rule.getViolationCodes();
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          violationCode = _ref[_i];
          _results.push('Not' + violationCode);
        }
        return _results;
      };

      NotValidatorRule.prototype.validate = function(value) {
        if (this.rule.isValid(value)) {
          return this.getViolationCodes();
        } else {
          return [];
        }
      };

      return NotValidatorRule;

    })(ValidatorRule);
  });

}).call(this);