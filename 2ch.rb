require "date"

def two_ch(name)
    def zero_add(time)
        if time.to_s.size == 1 then
            time = "0" + time.to_s
        end
        return time
    end
    time = Time.new + 3600 * 9
    d = Date.today

    date =  %w(日 月 火 水 木 金 土)[d.wday]
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
    return "#{$count} : #{name} : #{year}/#{mon}/#{day}(#{date}) #{hour}:#{min}:#{sec}:#{usec}\n"
end
