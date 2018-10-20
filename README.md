# node-validation-codes@1.0.0
## !!! This package is no longer maintained !!!
An AMD-module to validate user input both on client and server side returning easily parseable error codes.

Define a validator by combining rules:
```coffeescript
eMailValidator = new Rules.ViolationCodeModifier(new Rules.And([new Rules.Existence(), new Rules.Blacklist(),
                                                 new Rules.Email(), new Rules.MaxLength()]), 'Email')
```

This could be used to return error codes from a server side:
```coffeescript
unless eMailValidator.isValid "invalidMail@"
  return res.status(400).send                                              
    errors: eMailValidator.validate email 
```

Or to render alerts in a Backbone view:
```coffeescript
@$(".alert").remove()
if eMailValidator.isValid @$("input").val()
  @$el.removeClass "has-error"
else
  @$el.addClass "has-error"
  for code in eMailValidator.validate @$("input").val()
    @$(".alert-box").prepend alertTemplate
      type: "alert-danger"
      message: @getErrorMessage(code)
```
## API

The module can be required via node's require, or as an AMD module via requirejs. 
There is a [codo][codo] created documentation in the doc folder with more details.

### Available rules

* **And**: Valid if all of its sub-rules are valid 
* **Or**: Valid if any of its sub-rules is valid 
* **Blacklist**: Valid if the value is not in a predefined list or undefined 
* **Email**: Valid if the value confirms the W3C recommendation for email verification (not equivalent to RFC 5322!) or is undefined 
* **Existence**: Valid if the value exists
* **MaxLength**: Valid if the value is at most a maximum length or undefined 
* **MinLength**: Valid if the value is at least a minimum length or undefined 
* **Not**: Valid if the sub-rule is invalid 
* **Object**: Valid if the properties of the value confirm to the sub-rules set for the properties  
* **Regex**: Valid if the value confirms to a given regex or is undefined 
* **ViolationCodeModifier**: Valid if the sub-rule is valid. Used to prepend an identifier to the sub rules violation codes. 

### isValid

Will return true if the object to validate is valid.

### validate

Returns an Array with the rules violation code if it is violated.

[codo]: https://github.com/coffeedoc/codo
