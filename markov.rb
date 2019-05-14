require 'natto'
def mean_split (str)
  nm = Natto::MeCab.new
  mean = []
  nm.parse(str) do |n|
    n.feature.slice!(n.feature.index(",")..-1)
    mean.push(n.feature)
  end
  return mean
end

def analysis (t)
  nm = Natto::MeCab.new
  i = [""]
  cnt = 0
  ary = []
  nm.parse(t) do |n|
    i.push(n.surface)
  end
  (i.size - 3).times {ary.push([])}
  (i.size - 3).times do |j|
    (cnt..cnt + 3).each do |l|
      ary[j].push(i[l])
    end
  cnt += 1
  end 
  return ary
end

def chain(rensa, test)
  kouho = []
  flg = false
  test.each do |hoge|
    hoge.each do |huga|
      if rensa[-1] == huga[0] then
        kouho.push(huga)
      end
    end
  end
  
  ran = rand(kouho.size)
  #p kouho
  if kouho[ran].nil? then
    #puts "nilです"
    return rensa, true
  elsif kouho.empty? and !(kouho.nil?) then
    #puts "emptyです"
    return rensa, true
  else
    #puts "elseです"
    return rensa + kouho[ran][1..(kouho[ran].size)], false
  end
end  