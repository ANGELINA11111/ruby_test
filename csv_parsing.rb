require "csv"


marks = ['ПЭТД', 'ПЭТВ', 'ПуГВ', 'АПБ']
colors = ['красн','зелен','голуб','оранжев','желт','син','фиолет','бел','черн']
result = [] # список хешей(строк)

CSV.open('./test.csv', "r", { :col_sep => ";", :headers => true }).each do |row|
    dict = {}	# хеш каждой строки с нужными ключами
    one = row["Наименование"]
    split = one.split(/\s|-/)

    for mark in marks do
        for part, i in split.each_with_index do
            if mark.downcase == part.downcase
                dict['mark'] = mark
                mark_i = i
            end
        end
    end

    mark_next = split[mark_i + 1]
    
    version = nil
    if mark_next.match(/^\d+$|^ХЛ$/)
    	version = mark_next
    end
    dict['version'] = version

    split = one.split(/\s/)

    color = nil
    for part in split do
        r = part.match(/(^|\A|\s|\-)зел|черн|красн|желт*(\s|$|\Z|\-)/)
        if r
            color = part
        end
    end
    dict['color'] = color

    size = nil
    for part in split do
        r = part.match(/\d+(,\d+)?((x|х)\d+(,\d+)?)?(\d+(,\d+)?)?,?$/)
        if r
            size = part.strip()
        end
    end
    dict['size'] = size


    gost = nil
    dict['gost'] = gost
    for part, i in split.each_with_index do
        r = part.match(/^ТУ+$/)
        if r
            gost = part.strip()
            mark_next = split[i + 1]
            dict['gost'] = 'ТУ-' + mark_next
        end
        r = part.downcase.match(/^гост$/)
        if r
            dict['gost'] = 'ГОСТ'
        end
    end

    result << dict
end

puts result.inspect

