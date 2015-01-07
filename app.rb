require 'sinatra'
require 'json'
require 'sinatra/activerecord'

class Party < ActiveRecord::Base
  self.primary_key = :id
end

ActiveRecord::Base.configurations = YAML.load_file('database.yml')
ActiveRecord::Base.establish_connection(:development)

# create
post '/parties' do
  party = Party.new
  party[:id] = Date.today.strftime "%Y%m%d%H%M%s"
  party.begin_at = Date.today
  party.location = params[:location]
  party.owner = params[:owner]
  party.save
  { id: party.id }.to_json
end

# index
get '/parties' do
  Party.all.to_json
end

# show
get '/parties/:id' do
  Party.find_by_id(params[:id]).to_json
end
