require 'aws-sdk-v1'
require "twitter"
require 'http'
require 'json'
require "./markov"
def get_json
    AWS.config({
        :access_key_id => ENV["AWS_API_KEY"],
        :secret_access_key => ENV["AWS_SECRET_KEY"],
    })

    s3 = AWS::S3.new
    bucket = s3.buckets["neruneru"]
    $girak = bucket.objects["girak.json"]
    hash = $girak.read
    hash.force_encoding("utf-8")
    hash = JSON.load(hash)
    return hash
end

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

def two_ch(name)
    def zero_add(time)
        if time.to_s.size == 1 then
            time = "0" + time.to_s
        end
        return time
    end
    time = Time.new + 3600 * 9

    date =  ["日", "月", "火", "水", "木", "金", "土"][time.wday]
    year = time.year
    mon = zero_add(time.mon)
    day = zero_add(time.day)
    hour = zero_add(time.hour)
    min = zero_add(time.min)
    sec = zero_add(time.sec)
    usec = time.usec.to_s
    usec.slice!(-4..-1)
    usec = zero_add(usec)
    $count += 1
    $girak_value["count"] = $count
    $girak.write($girak_value.to_json)
    return "#{$count} : #{name} : #{year}/#{mon}/#{day}(#{date}) #{hour}:#{min}:#{sec}:#{usec}\n"
end

def command(text)
    if text[0] == "$" and text[-1] == "$" and text[1] != "@" and text.size <= 30 then
        $username[$user_id] = text[1..-2]
        $girak_value["count"] = $count
        $girak.write($girak_value.to_json)
        return [text]
    elsif text == "キーツとおはなし" then
        kitukitu = []
        client = Twitter::REST::Client.new do |config|
            config.consumer_key    = ENV['MY_CONSUMER_KEY']
            config.consumer_secret = ENV['MY_CONSUMER_SECRET']
            config.access_token    = ENV['MY_ACCESS_TOKEN']
            config.access_token_secret = ENV['MY_ACCESS_TOKEN_SECRET']
        end
        client.user_timeline("@koishihshs", {count: 200}).each do |tweet|
            unless tweet.text.include?("RT") or tweet.text.include?("@") or tweet.text.include?("http") then
                kitukitu.push(analysis(tweet.text))
                #p kitukitu
            end
        end
        learn_kitu = kitukitu.sample[0]
        flg = true
        loop do 
            p learn_kitu
            learn_kitu, flg = chain(learn_kitu, kitukitu)
            break if learn_kitu[-1].empty? or flg
        end
        return [learn_kitu.join]
    elsif text == "おみくじ" then
        isataku_fortune = [
            "大吉：ISATAKUのおごりでやよい軒",
            "大吉：ISATAKUのおごりで大戸屋",
            "大吉：ISATAKUのおごりで焼肉",
            "中吉：ISATAKUのおごりでマック",
            "超大吉：ISATAKUのおごりでディズニーシー",
            "大吉：ISATAKUのおごりでメロンパン1年分",
            "小吉：ISATAKUのおごりで自販機のコーラ",
            "小吉：ISATAKUのおごりでメロンパン一個",
            "凶：ISATAKUに財布をスられる",
            "中吉：ISATAKUがadobeを買収",
            "吉：ISATAKUのおごりで台湾旅行",
            "凶：ISATAKUがグーグルホームminiを買う",
            "中吉：ISATAKUのおごりでマック",
            ]
        return [isataku_fortune.sample]
    else
        return [text]
    end
end
