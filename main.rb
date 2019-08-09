require 'faye/websocket'
require 'aws-sdk-v1'
require 'twitter'
require 'http'
require 'json'
require 'eventmachine'
require "./unknown"
require "./girak"
requure "./get"
response = HTTP.post("https://slack.com/api/rtm.start", params: {
    token: ENV['SLACK_API_TOKEN']
  })
$girak_value = get_json
$count = $girak_value["count"]
$username = $girak_value["username"]
rc = JSON.parse(response.body)

url = rc['url']


EM.run do
  ary = []
  ary += girak_text("C8DCH0KA6")#random
  ary += girak_text("CAT2HJBQX")#mi 
  ary += girak_text("CEABD696C")#怪文書
  ary += girak_text("CBMJ0BMT6")#飯ん
  ary += girak_text("CBD6P1EF9")#pc
  ary += girak_text("CAT1J8H2T")#programming
  ary += girak_text("CFJAQRF3Q")#web
  ary += girak_text("CAZ7HSFU6")#os
  ws = Faye::WebSocket::Client.new(url)
  #  接続が確立した時の処理
  ws.on :open do
    p [:open]
  end

  ws.on :message do |event|
    data = JSON.parse(event.data)
    
    if data['text'].is_a?(String) then
      text = get_text
      ts = get_ts
        response = HTTP.post("https://slack.com/api/chat.delete", params: {
            token: ENV["NERUNERU_API_TOKEN"],
            channel: "CFG3HU6TA",
            ts: ts,
            as_user: true,
        })
    end
  end

  ws.on :close do
    p [:close, event.code]
    ws = nil
    EM.stop
  end
end
