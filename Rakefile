require 'fileutils'
require 'inifile'

desc "Compile everything"
task :default => [:structure, :bootstrap, :raw] do
  
end


task :structure do
  %w(content locale skin).each do |chrome_dir|
    FileUtils.mkdir_p "product/chrome/#{chrome_dir}"
  end
end

task :bootstrap do
  # system "cd javascripts; cp -R *.js ../product/chrome/content/"
  order = [
    "watch-windows",
    "login-manager",
    "bootstrap"
    ]
  system "cd javascripts; cat #{order.map{ |file| "#{file}.js"}.join(" ")} > ../product/bootstrap.js"
end

task :install do
  firefox_dir = ""
  if RUBY_PLATFORM =~ /darwin/i
    firefox_dir = File.join(ENV["HOME"], "Library", "Application Support", "Firefox")
  elsif RUBY_PLATFORM =~ /linux/i
    firefox_dir = File.join(ENV["HOME"], ".mozilla/firefox")
  end
  if firefox_dir.size == 0
    raise "Your OS is not supported at this time"
  end
  profile_file = IniFile.load(File.join(firefox_dir, "profiles.ini"))
  profile_index = 0
  profiles = []
  until profile_file["Profile#{profile_index}"].empty?
    profile = profile_file["Profile#{profile_index}"]
    profiles << {
      :name => profile["Name"],
      :path => profile["Path"]
    }
    profile_index += 1
  end
  profile = profiles.first
  if profiles.size > 1
    puts "Multiple profiles found"
    profiles.each_with_index do |profile, index|
      puts "#{index+1}: #{profile[:name]}"
    end
    print "Install in which profile? "
    profilenumber = STDIN.gets.strip.to_i
    if profilenumber > 0 and profilenumber <= profiles.size
      profile = profiles[profilenumber-1]
    else
      puts "Invalid profile number"
      return
    end
  end
  puts "Installing in #{profile[:path]}"
  target_path = File.join(File.expand_path("..",__FILE__),"product") + File::SEPARATOR
  extensions_dir = File.join(firefox_dir, profile[:path], "extensions")
  FileUtils.mkdir_p extensions_dir
  File.open(File.join(extensions_dir, "password-security@paneidos.net"), "w") do |file|
    file << target_path
  end
end

task :raw do
  system "cd raw; cp -R * ../product/"
end

