local s = {
    ["7381400395415"] = "loadstring(game:HttpGet(\'https://raw.githubusercontent.com/astral-123/Pickaxe-Tycoon/refs/heads/main/.lua\'))()",
}
local i = tostring(game.PlaceId)
if s[i] then
    loadstring(s[i])()
else
    print("Astral Hub: Jeu non supporté (" .. i .. "). Unsuportable games.")
end
