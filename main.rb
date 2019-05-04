require 'http'
require 'json'
require 'eventmachine'
require 'faye/websocket'
require './unknown'

response = HTTP.post("https://slack.com/api/rtm.start", params: {
    token: ENV['SLACK_API_TOKEN']
  })
$count = 0
$username = get_users
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

    if data['text'].is_a?(String) and flg then
      unknown()
      flg = false
    elsif data['text'].is_a?(String) and not flg then
      flg = true
    end
  end

  ws.on :close do
    p [:close, event.code]
    ws = nil
    EM.stop
  end
end