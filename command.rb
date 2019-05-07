def command(text)
    if text[0] == "$" and text[-1] == "$" then
        $username[$user_id] = text[1..-2]
        return text
    elsif text == "おみくじ" then
        isataku_fortune = [
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
            "凶：ISATAKUがグーグルホームminiを買う"]
        return isataku_fortune[rand(isataku_fortune.size)]
    else
        return text
    end
end