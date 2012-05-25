class LoginManager
  constructor: ->
  	if(!Components.classes['@mozilla.org/login-manager;1'])
  		@loginManager = null
  	else
  	  @loginManager = Components.classes['@mozilla.org/login-manager;1'].getService(Components.interfaces.nsILoginManager)
  
  allLogins: ->
    @loginManager.getAllLogins({})
    
  dumpLogins: ->
    for login in @allLogins()
      dump "Host: #{login.hostname}\n"
      dump "Username: #{login.username}\n"
      # dump "Password: #{login.password}\n"