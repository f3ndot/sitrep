# A sample Guardfile
# More info at https://github.com/guard/guard#readme

## Uncomment and set this to only include directories you want to watch
# directories %w(app lib config test spec features) \
#  .select{|d| Dir.exist?(d) ? d : UI.warning("Directory #{d} does not exist")}

## Note: if you are using the `directories` clause above and you are not
## watching the project directory ('.'), then you will want to move
## the Guardfile to a watched dir and symlink it back, e.g.
#
#  $ mkdir config
#  $ mv Guardfile config/
#  $ ln -s config/Guardfile .
#
# and, you'll have to watch "config/Guardfile" instead of "Guardfile"

notification :terminal_notifier, title: 'SITREP', app_name: "SITREP ::", activate: 'com.googlecode.iTerm2' if `uname` =~ /Darwin/

# guard 'puma' do
#   watch('Gemfile.lock')
#   watch('config.ru')
#   watch(%r{^.+\.rb})
# end

guard 'rack' do
  watch('Gemfile.lock')
  watch('config.ru')
  watch(%r{^.+\.rb})
end

# guard 'rack', port: 8500, config: 'mock_consul.ru' do
#   watch('Gemfile.lock')
#   watch('mock_consul.ru')
#   watch(%r{^.+\.rb})
# end
