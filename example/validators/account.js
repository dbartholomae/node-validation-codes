// Generated by CoffeeScript 1.9.0
(function() {
  define(['lib/ValidatorRules', './email', './password', './firstName', './lastName'], function(Rules, emailRule, passwordRule, firstNameRule, lastNameRule) {
    return new Rules.Object({
      email: emailRule,
      password: passwordRule,
      firstName: firstNameRule,
      lastName: lastNameRule
    });
  });

}).call(this);
