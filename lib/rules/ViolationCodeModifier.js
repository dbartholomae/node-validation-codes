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
    var ViolationCodeModifierValidatorRule;
    return ViolationCodeModifierValidatorRule = (function(_super) {
      __extends(ViolationCodeModifierValidatorRule, _super);

      function ViolationCodeModifierValidatorRule(rule, violationCodeModifierFunction, options) {
        this.rule = rule;
        if (typeof violationCodeModifierFunction === 'string') {
          violationCodeModifierFunction = (function(violationCodeModifierFunction) {
            return function(code) {
              return violationCodeModifierFunction + code;
            };
          })(violationCodeModifierFunction);
        }
        this.violationCodeModifierFunction = violationCodeModifierFunction;
        ViolationCodeModifierValidatorRule.__super__.constructor.call(this, options);
      }

      ViolationCodeModifierValidatorRule.prototype.setOptions = function(options) {
        this.rule.setOptions(options);
        return ViolationCodeModifierValidatorRule.__super__.setOptions.apply(this, arguments);
      };

      ViolationCodeModifierValidatorRule.prototype.getViolationCodes = function() {
        return this.rule.getViolationCodes().map(this.violationCodeModifierFunction);
      };

      ViolationCodeModifierValidatorRule.prototype.validate = function(value) {
        return this.rule.validate(value).map(this.violationCodeModifierFunction);
      };

      return ViolationCodeModifierValidatorRule;

    })(ValidatorRule);
  });

}).call(this);