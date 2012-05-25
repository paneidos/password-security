class LoginManager
  constructor: ->
  	if(!Components.classes['@mozilla.org/login-manager;1'])
  		@loginManager = null
  	else
  	  @loginManager = Components.classes['@mozilla.org/login-manager;1'].getService(Components.interfaces.nsILoginManager)
  	@events = {}
  	@event_names = "passwordmgr-found-form passwordmgr-storage-changed".split " "
  
  destroy: ->
    @loginManager = null
  
  allLogins: ->
    @loginManager.getAllLogins({})
    
  dumpLogins: ->
    for login in @allLogins()
      puts "Host: #{login.hostname}"
      puts "Username: #{login.username}"
      # dump "Password: #{login.password}\n"
  
  findByPassword: (password)->
    logins = []
    for login in @allLogins()
      if login.password == password
        logins.push
          host: login.hostname
          user: login.username
    logins
  
  bind: (eventName, func)->
    return if @event_names.indexOf(eventName) == -1
    @events[eventName] ||= []
    @events[eventName].push(func)
  
  observe: (subject,topic,data)->
    puts "Observe called"
    puts subject
    puts topic
    puts data
    if topic == "passwordmgr-storage-changed" and data == "addLogin"
      for key of subject
        puts "Key: #{key}"
      puts subject.username
      puts subject.password
    
  registerObserver: ->
    observerService = Components.classes["@mozilla.org/observer-service;1"].getService(Components.interfaces.nsIObserverService)
    for event_name in @event_names
      puts "Registering #{event_name}"
      observerService.addObserver(this, event_name,false)
  
  unregisterObserver: ->
    observerService = Components.classes["@mozilla.org/observer-service;1"].getService(Components.interfaces.nsIObserverService)
    for event_name in @event_names
      observerService.removeObserver(this, event_name)