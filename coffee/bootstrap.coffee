#=require login-manager

log = (msg)->
  consoleService = Components.classes["@mozilla.org/consoleservice;1"].getService(Components.interfaces.nsIConsoleService)
  consoleService.logStringMessage msg

real_startup = (data,reason)->
  # Do stuff
  log "Test"
  if getLoginManager() == null
    dump "Meh\n"
  dump "Blaat"
  loginManager = new LoginManager()
  loginManager.dumpLogins()

real_shutdown = (data,reason)->
  # Do stuff



getLoginManager = ->
  # // LoginManager only exists in Firefox 3:
	if(!Components.classes['@mozilla.org/login-manager;1'])
		return null
	return Components.classes['@mozilla.org/login-manager;1'].getService(Components.interfaces.nsILoginManager)


`function startup(data,reason) {
  return real_startup(data,reason);
}`

`function shutdown(data,reason) {
  return real_shutdown(data,reason);
}`
