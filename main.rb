require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/json'

post '/unknown' do
    sentence = params['text']
    return json({
        text: "sentence",
        response_type: 'in_channel',
    })
end

get '/' do
  "Hello World"
end