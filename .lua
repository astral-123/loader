local mt = getrawmetatable and getrawmetatable(game)
if mt then
    local old = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local m = getnamecallmethod()
        if m == "HttpGet" or m == "HttpGetAsync" then
            return "return nil"
        end
        return old(self, ...)
    end)
    setreadonly(mt, true)
end

local r = (syn and syn.request) or (http and http.request) or http_request or request
if r then
    local h = function(o)
        if type(o) == "table" and o.Url then
            return { StatusCode = 200, Body = "return nil", Headers = {} }
        end
        return r(o)
    end
    if syn and syn.request then syn.request = h
    elseif http and http.request then http.request = h
    elseif http_request then http_request = h
    elseif request then request = h end
end

local s = {
    ["13822562292"] = "loadstring(game:HttpGet('https://raw.githubusercontent.com/astral-123/midnight-chasser/refs/heads/main/.lua'))()", --midnight-chasser
}
local i = tostring(game.PlaceId)
if s[i] then
    loadstring(s[i])()
end
