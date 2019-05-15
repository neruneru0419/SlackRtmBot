require 'faye/websocket'
require 'aws-sdk-v1'
require 'twitter'
require 'http'
require 'json'
require 'eventmachine'
require "./unknown"
require "./girak"
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
  ary += girak_text("C8DCH0KA6")
  ary += girak_text("CAT2HJBQX") 
 #ary += girak_text("CJHUGT97W")
 #ary += girak_text("CF51F0YFR") 
  ary += girak_text("CEABD696C")
  ary += girak_text("CBMJ0BMT6")
  ary += girak_text("CAZ7HSFU6")
  ws = Faye::WebSocket::Client.new(url)
  flg = true
  flg2 = true

  #  接続が確立した時の処理
  ws.on :open do
    p [:open]
  end

  ws.on :message do |event|
    data = JSON.parse(event.data)
    #p [:message, data]
    
    if data['text'].is_a?(String) then
      if data['channel'] == 'CFG3HU6TA' then
        if flg then
          unknown()
          flg = false
        else 
          flg = true
        end
      elsif data['channel'] == 'CJHUGT97W' then
        if flg2 then
          girak_learn(ary)
          flg2 = false
        else 
          flg2 = true
        end
      end
    end
  end

  ws.on :close do
    p [:close, event.code]
    ws = nil
    EM.stop
  end
end
