#=require login-manager

log = (msg)->
  consoleService = Components.classes["@mozilla.org/consoleservice;1"].getService(Components.interfaces.nsIConsoleService)
  consoleService.logStringMessage msg

puts = (msg)->
  dump "#{msg}\n"

loginManager = null

formFound = (data)->
  # puts "Form found"
  return

form_submit = (event)->
  password_fields = event.originalTarget.querySelectorAll("form input[type=password]")
  if password_fields.length == 1
    # puts "Login form detected, no action taken"
    return
  # else if password_fields.length > 1
  #   puts "Multiple password fields found, comparing values"
  else if password_fields.length == 0
    return
  password_confirmation_found = false
  field = null
  for i in [0...(password_fields.length)]
    for j in [(i+1)..(password_fields.length)]
      if password_fields[i].value == password_fields[j].value
        password_confirmation_found = true
        field = password_fields[i]
        break
    break if password_confirmation_found
  if password_confirmation_found
    # puts "Password confirmation detected"
    
    # Test for secure site
    protocol = event.originalTarget.ownerDocument.location.protocol
    
    if event.originalTarget.action.substring(0,8) == "https://"
      protocol = "https:"
    else if event.originalTarget.action.substring(0,7) == "http://"
      protocol = "http:"
    
    thisSiteSecure = protocol.substring(0,5) == "https"
    
    otherSites = loginManager.findByPassword(field.value)
    # puts "Used in other sites: #{otherSites.length}"
    usedInSecureSite = false
    usedInInsecureSite = false
    secureSites = []
    insecureSites = []
    for site in otherSites
      if site.host.substring(0,7) == "http://"
        usedInInsecureSite = true
        insecureSites.push site
      else if site.host.substring(0,8) == "https://"
        usedInSecureSite = true
        secureSites.push site
      # puts "#{site.user} - #{site.host}"
    if otherSites.length > 0
      message = "This password is also used for the following"
      sites = otherSites
      if usedInInsecureSite and thisSiteSecure
        message = "This password is also used for the following insecure"
        sites = insecureSites
      else if usedInSecureSite and !thisSiteSecure
        message = "This password is also used for the following secure"
        sites = secureSites
      if sites.length == 1
        message += " site:\n"
      else
        message += " sites:\n"
      if sites.length > 4
        for i in [0...3]
          message += "* #{sites[i].host}\n"
        message += "* and #{sites.length - 5} other sites\n"
      else
        for site in sites
          message += "* #{site.host}\n"
      message += "\n"
      message += "Are you sure you want to re-use this password?\n"
      result = event.originalTarget.ownerDocument.defaultView.confirm message
      unless result
        event.preventDefault()
  return

delay = (time,func)->
  setTimeout(func,time)

bind_new_forms = (event)->
  # puts "DOM CONTENT ADDED"
  # puts event.originalTarget
  # delay 0, ->
  #   puts "Delayed"

load_page = (event)->
  # puts "PAGE LOAD"
  doc = event.originalTarget
  # puts doc
  doc.addEventListener "submit", form_submit, false

real_startup = (data,reason)->
  # Do stuff
  # if getLoginManager() == null
  #   puts "Meh"
  # puts "Blaat"
  loginManager = new LoginManager()
  loginManager.dumpLogins()
  watchWindows (window)->
    # puts "Found Window!"
    if window.document?
      # puts "Has document"
      appcontent = window.document.getElementById("appcontent")   # browser  
      if appcontent
        # puts "Found appcontent"
        appcontent.addEventListener "DOMContentLoaded", load_page, true
        appcontent.addEventListener "DOMNodeInserted", bind_new_forms, true
      else
        # puts "Could not bind event"
    loginManager.registerObserver()
  undefined

real_shutdown = (data,reason)->
  # Do stuff
  # loginManager.unregisterObserver()
  loginManager.destroy()
  unloadWatchWindows()
  undefined


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
