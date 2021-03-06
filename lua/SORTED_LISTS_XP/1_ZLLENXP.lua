-- SORTED LISTS with EXPIRE by member
-- ZLLENXP key

local ZSET_SCORE_KEY = KEYS[1]..".SCORE"
local ZSET_EXPIREAT_KEY = KEYS[1]..".EXPIREAT"
local now = tonumber(redis.call('TIME')[1])

local count = 0
local expireAt = nil

for i, v in pairs(redis.call('LRANGE', KEYS[1], KEYS[2], KEYS[3])) do
    expireAt = tonumber(redis.call('ZSCORE', ZSET_EXPIREAT_KEY, v))
    if type(expireAt) ~= "number" then
    elseif expireAt < now then
        redis.call('ZREM', ZSET_SCORE_KEY, v)
        redis.call('ZREM', ZSET_EXPIREAT_KEY, v)
    else
        count = count + 1
    end
end
return count