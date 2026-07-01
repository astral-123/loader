local s = {
    ["73814003954154"] = "loadstring(game:HttpGet('https://raw.githubusercontent.com/astral-123/Pickaxe-Tycoon/refs/heads/main/.lua'))()",
    ["13822562292"] = "loadstring(game:HttpGet('https://raw.githubusercontent.com/astral-123/midnight-chasser/refs/heads/main/.lua'))()",
    ["13110267312"] = "loadstring(game:HttpGet("https://raw.githubusercontent.com/astral-123/AU/refs/heads/main/.lua"))()",
}
local i = tostring(game.PlaceId)
if s[i] then
    loadstring(s[i])()
else
    print("Astral Hub: Jeu non supporté (" .. i .. "). Unsuportable games.")
end
