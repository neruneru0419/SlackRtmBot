require "./markov"
require "http"
require "json"
def girak_text(str)
    kitukitu = []
    response = HTTP.post("https://slack.com/api/channels.history", params: {
        token: ENV['SLACK_API_TOKEN'],
        channel: str,
        count: 1000,
    })
    
    hash = JSON.parse(response)
    (hash["messages"].size).times do |hoge|
        girak_text = hash["messages"][hoge]["text"]
        if !( girak_text[0].nil?) and girak_text[0] != ":" and girak_text[0] != "<" then
            #puts girak_text
            kitukitu.push(analysis(girak_text))
        end
    end
    return kitukitu
end

def girak_learn(kitukitu)

    puts kitukitu.size
    learn_kitu = kitukitu.sample[0]
    flg = true
    p learn_kitu
    loop do 
        learn_kitu, flg = chain(learn_kitu, kitukitu)
        p learn_kitu
        break if learn_kitu[-1].empty? or flg or (100 <= learn_kitu.join.size)
    end
    puts learn_kitu.join
    response = HTTP.post("https://slack.com/api/chat.postMessage", params: {
        token: ENV["SLACK_API_TOKEN"],
        channel: "CJHUGT97W",
        text:learn_kitu.join,
        as_user: true,
    })
end
