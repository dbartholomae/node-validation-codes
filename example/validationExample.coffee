requirejs = require 'requirejs'

requirejs.config
  baseUrl: '../'

account = requirejs 'example/validators/account'

# Will write ['EmailNotAnEmail', 'PasswordTooShort']
console.log account.validate
  email: "invalidMail@"
  password: "Short"
  firstName: "John"
  lastName: null
