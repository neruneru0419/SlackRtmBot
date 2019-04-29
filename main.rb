require 'http'
require 'json'
require 'sinatra'
require "./get"

nowtext = ""
post '/' do
    text = get_text
    ts = get_ts
    if nowtext != text then
        response = HTTP.post("https://slack.com/api/chat.delete", params: {
            token: ENV["NERUNERU_API_TOKEN"],
            channel: "CFG3HU6TA",
            ts: ts,
            as_user: true,
        })

        response = HTTP.post("https://slack.com/api/chat.postMessage", params: {
            token: ENV["SLACK_API_TOKEN"],
            channel: "CFG3HU6TA",
            text: text,
            as_user: true,
        })
        nowtext = text
        puts JSON.pretty_generate(JSON.parse(response.body))
    end
end