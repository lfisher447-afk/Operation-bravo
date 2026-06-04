--!strict
local Trail = {}
function Trail.new(cap: number): any
    local n = math.max(2, math.floor(cap))
    local d = table.create(n)
    local h, c = 0, 0
    local t = {}
    function t:push(v)
        h = (h % n) + 1
        d[h] = v
        if c < n then c += 1 end
    end
    function t:head()
        if c == 0 then return nil end
        return d[h]
    end
    function t:prev()
        if c < 2 then return nil end
        local i = h - 1
        if i < 1 then i = n end
        return d[i]
    end
    function t:wipe()
        table.clear(d)
        h, c = 0, 0
    end
    function t:size() return c end
    function t:sum()
        local s = 0
        for i = 1, c do s += d[i] end
        return s
    end
    function t:avg()
        if c == 0 then return 0 end
        return t:sum() / c
    end
    return t
end
return table.freeze(Trail)