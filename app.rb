require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/json'
require 'sinatra/activerecord'

class Party < ActiveRecord::Base
  has_many :guests
  self.primary_key = :id
end

class Guest < ActiveRecord::Base
  belongs_to :party
  self.primary_key = :id
end

ActiveRecord::Base.configurations = YAML.load_file('database.yml')
ActiveRecord::Base.establish_connection(:development)

# create parties
post '/parties' do
  party = Party.new
  party.id = SecureRandom.uuid
  party.begin_at = params[:begin_at]
  party.location = params[:location]
  party.owner = params[:owner]
  party.save
  res = { id: party[:id] }
  json res
end

# add guest to party
post '/parties/:party_id/guests' do
  guest = Guest.new
  guest.id = SecureRandom.uuid
  guest.party_id = params[:party_id]
  guest.name = params[:name]
  guest.save
  res = { id: guest[:id] }
  json res
end

# get parties
get '/parties' do
  json Party.all
end

# get party detail
get '/parties/:party_id' do
  parties = Party.find_by_id(params[:party_id]).attributes
  parties[:guests] = Guest.where(:party_id => params[:party_id])
  json parties
end

# get recorded message
get '/parties/:party_id/guests/:guest_id/message' do
  # TODO: get message from twilio
  res = { message: 'sample' }
  json res
end