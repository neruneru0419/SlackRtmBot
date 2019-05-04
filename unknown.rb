require 'http'
require 'json'
require "./get"
require "./2ch"

def unknown
    text = get_text
    ts = get_ts
        response = HTTP.post("https://slack.com/api/chat.delete", params: {
            token: ENV["NERUNERU_API_TOKEN"],
            channel: "CFG3HU6TA",
            ts: ts,
            as_user: true,
        })

        response = HTTP.post("https://slack.com/api/chat.postMessage", params: {
            token: ENV["SLACK_API_TOKEN"],
            channel: "CFG3HU6TA",
            text: two_ch + text + "\n",
            as_user: true,
        })
        puts JSON.pretty_generate(JSON.parse(response.body))
end