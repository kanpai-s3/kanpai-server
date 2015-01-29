require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'

ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || Proc.new do
  ActiveRecord::Base.configurations = YAML.load_file('database.yml')
  :development
end.call)
