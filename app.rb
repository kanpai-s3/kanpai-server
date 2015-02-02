require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/json'
require 'sinatra/activerecord'
require 'twilio-ruby'

ATTEND = '9';
RECORD = '9';

class Party < ActiveRecord::Base
  has_many :guests
  self.primary_key = :id
end

class Guest < ActiveRecord::Base
  belongs_to :party
  self.primary_key = :id
end

ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || Proc.new do
  ActiveRecord::Base.configurations = YAML.load_file('database.yml')
  :development
end.call)

# create parties
post '/parties' do
  party = Party.new
  party.id = SecureRandom.uuid
  party.begin_at = params[:begin_at]
  party.location = params[:location]
  party.owner = params[:owner]
  party.message = params[:message]
  party.save
  res = { id: party[:id] }
  json res
end

# add guest to party
post '/parties/:party_id/guests' do
  party = Party.find_by_id(params[:party_id])
  party.guests.build(
    id: SecureRandom.uuid,
    name: params[:name],
    phone_number: params[:phone_number]
  )
  party.save
  # TODO: start invitation call
  res = { id: party.guests.last.id }
  json res
end

# get parties
get '/parties' do
  json Party.all
end

# get party detail
get '/parties/:party_id' do
  party = Party.find_by_id(params[:party_id])
  guests = party.guests
  party_detail = party.attributes
  party_detail[:guests] = guests
  json party_detail
end

# get recorded message
get '/guests/:guest_id/message' do
  # TODO: get message from twilio
  res = { message: 'sample' }
  json res
end

# TwiML for attendance
get '/guests/:guest_id/twiml/can_attend' do
  party = Party.joins(:guests).where(guests: {id: params[:guest_id]}).first
  p party
  response = Twilio::TwiML::Response.new do |r|
    r.Say party.owner + 'さんから飲み会に誘われています', :voice => 'woman', :language => 'ja-jp'
    r.Pause :length => 1
    r.Say '開始時間は' + party.begin_at.hour.to_s + '時です', :voice => 'woman', :language => 'ja-jp'
    r.Pause :length => 1
    r.Gather :action => '/guests/' + params[:guest_id] + '/twiml/can_attend',
      :method => 'POST',
      :timeout => 10,
      :finishOnKey => '#',
      :numDigits => 1 do
        r.Say '飲み会に参加の場合は9を不参加の場合はそれ以外のキーを押して下さい', :voice => 'woman', :language => 'ja-jp'
    end
  end
  content_type 'text/xml'
  response.to_xml
end

post '/guests/:guest_id/twiml/can_attend' do
  entered_num = params[:Digits]
  p 'entered: ' + entered_num
  # TODO: save attendance
  response = Twilio::TwiML::Response.new do |r|
    r.Redirect '/guests/' + params[:guest_id] + '/twiml/will_record', :method => 'GET'
  end
  content_type 'text/xml'
  response.to_xml
end

# TwiML for record
get '/guests/:guest_id/twiml/will_record' do
  party = Party.joins(:guests).where(guests: {id: params[:guest_id]}).first
  response = Twilio::TwiML::Response.new do |r|
    r.Gather :action => '/guests/' + params[:guest_id] + '/twiml/will_record',
      :method => 'POST',
      :timeout => 10,
      :finishOnKey => '#',
      :numDigits => 1 do
        r.Say party.owner + 'さんにメッセージを残す場合は9をメッセージを残さない場合はそれ以外のキーを押して下さい', :voice => 'woman', :language => 'ja-jp'
    end
  end
  content_type 'text/xml'
  response.to_xml
end

post '/guests/:guest_id/twiml/will_record' do
  p "digits" + params[:Digits]
  if RECORD == params[:Digits]
    path = '/guests/' + params[:guest_id] + '/twiml/record'
  else
    path = '/guests/' + params[:guest_id] + '/twiml/end_call'
  end
  response = Twilio::TwiML::Response.new do |r|
    r.Redirect path, :method => 'GET'
  end
  content_type 'text/xml'
  response.to_xml
end

get '/guests/:guest_id/twiml/record' do
  party = Party.joins(:guests).where(guests: {id: params[:guest_id]}).first
  response = Twilio::TwiML::Response.new do |r|
    r.Say 'ピーという発信音の後に' + party.owner + 'さんへのメッセージをお話しください', :voice => 'woman', :language => 'ja-jp'
    r.Pause :length => 1
    r.Record :action => '/guests/' + params[:guest_id] + '/twiml/record',
    :method => 'POST',
    :finishOnKey => '#',
    :timeout => 10
  end
  content_type 'text/xml'
  response.to_xml
end

post '/guests/:guest_id/twiml/record' do
  recordingUrl = params[:RecordingUrl]
  p recordingUrl
  # TODO: save recordingUrl
  response = Twilio::TwiML::Response.new do |r|
    r.Redirect '/guests/' + params[:guest_id] + '/twiml/end_call', :method => 'GET'
  end
  content_type 'text/xml'
  response.to_xml
end

# exit call
get '/guests/:guest_id/twiml/end_call' do
  # TODO: end processing
  response = Twilio::TwiML::Response.new do |r|
    r.Say '通話を終了します', :voice => 'woman', :language => 'ja-jp'
  end
  content_type 'text/xml'
  response.to_xml
end