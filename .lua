local s = {
    ["1234"] = "loadstring(game:HttpGet("https://raw.githubusercontent.com/astral-123/jailbird/refs/heads/main/.lua"))()",
}
local i = tostring(game.PlaceId)
if s[i] then loadstring(s[i])() end
