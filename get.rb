require 'http'
require 'json'
def get_ts
    response = HTTP.post("https://slack.com/api/channels.history", params: {
        token: ENV['SLACK_API_TOKEN'],
        channel: "CFG3HU6TA",
        count: 1,
    })
    hash = JSON.parse(response)
    puts hash
    puts hash["messages"][0]["ts"]
    return hash["messages"][0]["ts"]
end

def get_text
    response = HTTP.post("https://slack.com/api/channels.history", params: {
        token: ENV['SLACK_API_TOKEN'],
        channel: "CFG3HU6TA",
        count: 1,
    })
    hash = JSON.parse(response)
    return hash["messages"][0]["text"]
end