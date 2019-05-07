require 'http'
require 'json'
require "./command"
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
    post_text = hash["messages"][0]["text"]
    $user_id = hash["messages"][0]["user"]
    return_text = command(post_text)
    return return_text
end

def get_users
    response = HTTP.post("https://slack.com/api/users.list", params: {
        token: ENV['SLACK_API_TOKEN'],
    })
    result = []
    hash = JSON.parse(response)
    p hash.class
    hash["members"].size.times do |hoge|
        result.push([])
        result[hoge].push(hash["members"][hoge]["id"])
        result[hoge].push("名無しのギラクさん")
    end
    return result.to_h
end

