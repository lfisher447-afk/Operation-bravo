--strict
local RateLimiter = {}
RateLimiter.__index = RateLimiter
function RateLimiter.new(ratePerSecond: number, burst: number)
    return setmetatable({ _rate = math.max(1, ratePerSecond), _burst = math.max(1, burst), _buckets = {} }, RateLimiter)
end
function RateLimiter:take(key: string, now: number): boolean
    local b = self._buckets[key]
    if b == nil then
        self._buckets[key] = { tokens = self._burst - 1, stamp = now }
        return true
    end
    local gap = now - b.stamp
    if gap > 0 then
        b.tokens = math.min(self._burst, b.tokens + gap * self._rate)
        b.stamp = now
    end
    if b.tokens < 1 then return false end
    b.tokens -= 1
    return true
end
function RateLimiter:forget(key: string) self._buckets[key] = nil end
return RateLimiter