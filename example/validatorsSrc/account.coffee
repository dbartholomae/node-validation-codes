define ['lib/ValidatorRules', './email', './password', './firstName', './lastName'],
(Rules, emailRule, passwordRule, firstNameRule, lastNameRule) ->
  new Rules.Object
    email: emailRule
    password: passwordRule
    firstName: firstNameRule
    lastName: lastNameRule