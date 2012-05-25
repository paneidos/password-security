# A sample Guardfile
# More info at https://github.com/guard/guard#readme


guard 'coffeescript', :input => 'coffee', :output => 'javascripts', :bare => true, :all_on_start => true
guard :shell, :all_on_start => true do
  watch(/javascripts\/.*$/) do
    `bundle exec rake`
  end
end
