require 'aws-sdk-v1'
require 'http'
require 'json'
require 'eventmachine'
require 'faye/websocket'
require './unknown'

response = HTTP.post("https://slack.com/api/rtm.start", params: {
    token: ENV['SLACK_API_TOKEN']
  })
$girak_value = get_json
$count = $girak_value["count"]
$username = $girak_value["username"]
rc = JSON.parse(response.body)

url = rc['url']

EM.run do
  # Web Socketインスタンスの立ち上げ
  ws = Faye::WebSocket::Client.new(url)
  flg = true

  #  接続が確立した時の処理
  ws.on :open do
    p [:open]
  end

  ws.on :message do |event|
    data = JSON.parse(event.data)
    p [:message, data]

    if data['text'].is_a?(String) and data['channel'] == 'CFG3HU6TA' then
      if flg then
        unknown()
        flg = false
      else 
        flg = true
      end
    end
  end

  ws.on :close do
    p [:close, event.code]
    ws = nil
    EM.stop
  end
end