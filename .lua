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

if not shared then
	return warn("No shared, no script.")
end

-- Services.
local playersService = game:GetService("Players")
local tweenService   = game:GetService("TweenService")

local localPlayer    = playersService.LocalPlayer
local currentPlaceId = game.PlaceId

-- Script registry: [placeId] = { url = "rawurl", name = "Game Name" }
local SCRIPTS = {
	[142823291] = { url = "https://raw.githubusercontent.com/astral-123/Murder-Mystery-2/refs/heads/main/.lua", name = "Murder Mystery 2"     }, -- Murder Mystery 2
}

local BG_IMAGE = "rbxassetid://132565349151183"

local FAST   = TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local SPRING = TweenInfo.new(0.42, Enum.EasingStyle.Back,  Enum.EasingDirection.Out)

local UI_W, UI_H = 560, 370

local COL_WHITE  = Color3.fromRGB(195, 200, 215)
local COL_GREEN  = Color3.fromRGB(75,  210, 115)
local COL_YELLOW = Color3.fromRGB(215, 195, 55)
local COL_RED    = Color3.fromRGB(215, 70,  70)
local COL_BLUE   = Color3.fromRGB(75,  150, 215)
local COL_DIM    = Color3.fromRGB(85,  90,  115)
local COL_DIMMER = Color3.fromRGB(50,  54,  72)

local gui = Instance.new("ScreenGui")
gui.Name           = "AstralTerminal"
gui.ResetOnSpawn   = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent         = gethui and gethui() or localPlayer:WaitForChild("PlayerGui")



-- Main window - dark grey.
local main = Instance.new("Frame")
main.Name             = "Main"
main.Size             = UDim2.new(0, 1, 0, 1)
main.AnchorPoint      = Vector2.new(0.5, 0.5)
main.Position         = UDim2.new(0.5, 0, 0.5, 0)
main.BackgroundColor3 = Color3.fromRGB(22, 23, 28)
main.BorderSizePixel  = 0
main.ZIndex           = 2
main.Active           = true
main.Draggable        = true
main.Parent           = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)

local mainStroke = Instance.new("UIStroke")
mainStroke.Color     = Color3.fromRGB(40, 42, 55)
mainStroke.Thickness = 1
mainStroke.Parent    = main

-- Background image.
local bgImage = Instance.new("ImageLabel")
bgImage.Size               = UDim2.new(1, 0, 1, 0)
bgImage.BackgroundTransparency = 1
bgImage.Image              = BG_IMAGE
bgImage.ImageTransparency  = 0.55
bgImage.ScaleType          = Enum.ScaleType.Crop
bgImage.ZIndex             = 2
bgImage.Parent             = main
Instance.new("UICorner", bgImage).CornerRadius = UDim.new(0, 8)

-- Dim layer on top of image.
local dimLayer = Instance.new("Frame")
dimLayer.Size             = UDim2.new(1, 0, 1, 0)
dimLayer.BackgroundColor3 = Color3.fromRGB(18, 19, 24)
dimLayer.BackgroundTransparency = 0.3
dimLayer.BorderSizePixel  = 0
dimLayer.ZIndex           = 3
dimLayer.Parent           = main
Instance.new("UICorner", dimLayer).CornerRadius = UDim.new(0, 8)

-- Title bar.
local titleBar = Instance.new("Frame")
titleBar.Size             = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(14, 15, 19)
titleBar.BorderSizePixel  = 0
titleBar.ZIndex           = 4
titleBar.Parent           = main
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 8)

local titleFix = Instance.new("Frame")
titleFix.Size             = UDim2.new(1, 0, 0, 8)
titleFix.Position         = UDim2.new(0, 0, 1, -8)
titleFix.BackgroundColor3 = Color3.fromRGB(14, 15, 19)
titleFix.BorderSizePixel  = 0
titleFix.ZIndex           = 4
titleFix.Parent           = titleBar

local function makeCircle(parent, xOff, col)
	local c = Instance.new("Frame")
	c.Size             = UDim2.new(0, 10, 0, 10)
	c.Position         = UDim2.new(0, xOff, 0.5, -5)
	c.BackgroundColor3 = col
	c.BorderSizePixel  = 0
	c.ZIndex           = 5
	c.Parent           = parent
	Instance.new("UICorner", c).CornerRadius = UDim.new(1, 0)
end
makeCircle(titleBar, 12, Color3.fromRGB(255, 95,  86))
makeCircle(titleBar, 28, Color3.fromRGB(255, 189, 46))
makeCircle(titleBar, 44, Color3.fromRGB(39,  201, 63))

local titleLabel = Instance.new("TextLabel")
titleLabel.Size               = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text               = "Astral Terminal"
titleLabel.TextColor3         = Color3.fromRGB(120, 124, 148)
titleLabel.TextSize           = 12
titleLabel.Font               = Enum.Font.Code
titleLabel.ZIndex             = 5
titleLabel.Parent             = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size               = UDim2.new(0, 30, 0, 30)
closeBtn.Position           = UDim2.new(1, -30, 0, 0)
closeBtn.BackgroundTransparency = 1
closeBtn.Text               = "SK"
closeBtn.TextColor3         = COL_DIMMER
closeBtn.TextSize           = 11
closeBtn.Font               = Enum.Font.GothamBold
closeBtn.ZIndex             = 6
closeBtn.Visible            = false
closeBtn.Parent             = titleBar

-- Terminal scroll.
local scroll = Instance.new("ScrollingFrame")
scroll.Size                = UDim2.new(1, -24, 1, -40)
scroll.Position            = UDim2.new(0, 12, 0, 34)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel     = 0
scroll.ScrollBarThickness  = 2
scroll.ScrollBarImageColor3 = Color3.fromRGB(40, 42, 60)
scroll.CanvasSize          = UDim2.new(0, 0, 0, 0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.ZIndex              = 4
scroll.Parent              = main

local scrollLayout = Instance.new("UIListLayout")
scrollLayout.Padding = UDim.new(0, 1)
scrollLayout.Parent  = scroll

local scrollPad = Instance.new("UIPadding")
scrollPad.PaddingTop    = UDim.new(0, 6)
scrollPad.PaddingBottom = UDim.new(0, 8)
scrollPad.Parent        = scroll

---Add a terminal line instantly.
---@param text string
---@param col Color3
local function addLine(text, col)
	local lbl = Instance.new("TextLabel")
	lbl.Size               = UDim2.new(1, 0, 0, 18)
	lbl.BackgroundTransparency = 1
	lbl.Text               = text
	lbl.TextColor3         = col or COL_WHITE
	lbl.TextSize           = 12
	lbl.Font               = Enum.Font.Code
	lbl.TextXAlignment     = Enum.TextXAlignment.Left
	lbl.RichText           = true
	lbl.ZIndex             = 5
	lbl.Parent             = scroll
	scroll.CanvasPosition  = Vector2.new(0, math.huge)
	return lbl
end

---Add a line with fast typewriter (3 chars per tick).
---@param text string
---@param col Color3
local function addTyped(text, col)
	local lbl = Instance.new("TextLabel")
	lbl.Size               = UDim2.new(1, 0, 0, 18)
	lbl.BackgroundTransparency = 1
	lbl.Text               = ""
	lbl.TextColor3         = col or COL_WHITE
	lbl.TextSize           = 12
	lbl.Font               = Enum.Font.Code
	lbl.TextXAlignment     = Enum.TextXAlignment.Left
	lbl.RichText           = true
	lbl.ZIndex             = 5
	lbl.Parent             = scroll

	local i = 1
	while i <= #text do
		lbl.Text = string.sub(text, 1, i)
		scroll.CanvasPosition = Vector2.new(0, math.huge)
		i = i + 3
		task.wait(0.016)
	end
	lbl.Text = text
	return lbl
end

local function addBlank()
	local f = Instance.new("Frame")
	f.Size               = UDim2.new(1, 0, 0, 5)
	f.BackgroundTransparency = 1
	f.ZIndex             = 5
	f.Parent             = scroll
end

local function openUI()
	tweenService:Create(main, SPRING, { Size = UDim2.new(0, UI_W, 0, UI_H) }):Play()
end

local function closeUI()
	local t = tweenService:Create(main, FAST, { Size = UDim2.new(0, UI_W, 0, 1) })
	t:Play()
	t.Completed:Wait()
	gui:Destroy()
end

closeBtn.MouseButton1Click:Connect(closeUI)
closeBtn.MouseEnter:Connect(function() closeBtn.TextColor3 = COL_RED end)
closeBtn.MouseLeave:Connect(function() closeBtn.TextColor3 = COL_DIMMER end)

openUI()

task.spawn(function()
	task.wait(0.4)

	addLine('<font color="#4b96d7">$</font>  astral --initialize', COL_WHITE)
	addBlank()
	task.wait(0.15)
	addTyped('<font color="#4b96d7">[INFO]</font>    Initializing Astral Terminal...', COL_WHITE)
	task.wait(0.1)
	addTyped('<font color="#4bc873">[ OK ]</font>    Interface loaded.', COL_WHITE)
	task.wait(0.1)
	addTyped('<font color="#4bc873">[ OK ]</font>    Pipeline mounted.', COL_WHITE)
	addBlank()
	task.wait(0.15)
	addTyped('> Searching for supported game...', COL_DIM)
	addBlank()
	task.wait(0.2)

	local entry = SCRIPTS[currentPlaceId]

	if entry then
		addTyped('<font color="#4bc873">[ OK ]</font>    Game detected: ' .. entry.name, COL_WHITE)
		task.wait(0.1)
		addTyped('<font color="#4bc873">[ OK ]</font>    Loading script...', COL_WHITE)
		addBlank()

		local ok, err = pcall(function()
			local fn, compileErr = loadstring(game:HttpGet(entry.url))
			assert(fn, compileErr or "compile error")
			fn()
		end)

		if ok then
			addTyped('<font color="#4bc873">[ OK ]</font>    Script loaded.', COL_WHITE)
			addBlank()
			local closingLbl = addLine('> Closing in 5s...', COL_DIMMER)
			for i = 4, 1, -1 do
				task.wait(1)
				closingLbl.Text = '> Closing in ' .. i .. 's...'
			end
			task.wait(1)
			closeUI()
		else
			addTyped('<font color="#d74b4b">[WARN]</font>    Failed to load script.', COL_WHITE)
			addLine('<font color="#d74b4b">[WARN]</font>    ' .. tostring(err), COL_WHITE)
			addBlank()
			addLine('> Close manually.', COL_DIMMER)
			closeBtn.Visible = true
		end
	else
		addTyped('<font color="#d7c24b">[WARN]</font>    No supported game found.', COL_WHITE)
		addTyped('<font color="#d7c24b">[WARN]</font>    No compatible script for this game.', COL_WHITE)
		addBlank()
		addLine('> Supported games:', COL_DIM)
		task.wait(0.1)
		for _, e in pairs(SCRIPTS) do
			addLine('  <font color="#4bc873">•</font> ' .. e.name, COL_DIMMER)
			task.wait(0.06)
		end
		addBlank()
		addLine('> Closing loader...', COL_DIMMER)
		task.wait(1)
		closeBtn.Visible = true
	end
end)
