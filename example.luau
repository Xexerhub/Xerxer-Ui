--[[
    XexerUI — example.luau
    ---------------------------------------------------------------
    A full showcase of every element the library ships with.

    HOW TO USE
      1. Publish source.luau somewhere reachable (raw GitHub, pastebin, ...).
      2. Put that URL in SRC_URL below.
      3. Run this file with your executor.

    Requires an executor (loadstring / game:HttpGet).
    Everything here is local-only demo data — safe to run anywhere.
]]

--!nocheck

local SRC_URL = "https://raw.githubusercontent.com/Xexerhub/Xerxer-Ui/refs/heads/main/source.luau"

-- Load the library. (If you already have `XexerUI` in scope, delete these 2 lines.)
local ok, XexerUI = pcall(function()
	return loadstring(game:HttpGet(SRC_URL))()
end)
if not ok or type(XexerUI) ~= "table" then
	error("[example] could not load XexerUI from " .. SRC_URL .. " -> " .. tostring(XexerUI), 0)
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ============================================================
--  WINDOW
-- ============================================================
local Window = XexerUI:CreateWindow({
	Title = "XexerUI — Showcase",
	Author = "777",
	Version = "v1.0",
	Tags = { "Demo", "All Elements" },
	Width = 680,
	Height = 480,
	-- Logo = "rbxassetid://0",   -- optional; false / omitted = no logo
	Search = false,             -- window search box (sidebar element search vs. Spotlight)
	Blur = 20,
	ConfigAutoSave = false,     -- demo: don't write configs automatically
	OnReady = function(win)
		win:Notify({ Title = "XexerUI loaded", Content = "Have a look around.", Type = "Success", Icon = "check" })
	end,
})

-- Window-level commands show up inside Spotlight (Ctrl/Cmd + K)
Window:Command({ Title = "Open Spotlight", Description = "Search everything", Icon = "search", Callback = function() Window:Spotlight({ Open = true }) end })
Window:Command({ Title = "Rainbow accent", Description = "Toggle animated accent", Icon = "palette", Callback = function() Window:RainbowAccent(true) end })
Window:Command({ Title = "Changelog", Description = "Show what's new", Icon = "list", Callback = function() Window:Changelog({ Title = "What's New", Version = "v1.0", Changes = { "Initial release", "Every element demoed", "Theme editor" } }) end })
Window:Spotlight({})

-- ============================================================
--  TAB 1 — HOME
-- ============================================================
Window:SidebarSection("General")
local Home = Window:Tab({ Title = "Home", Icon = "home", Default = true })
do
	local s = Home:Section({ Title = "Welcome", Icon = "sparkles" })
	s:Banner({ Title = "XexerUI", SubTitle = "A clean, glassy Roblox UI library", Height = 104, Color = Color3.fromRGB(40, 40, 46), Color2 = Color3.fromRGB(90, 90, 100) })
	s:UserInfo({})
	s:Tags({
		{ Text = "Stable", Color = Color3.fromRGB(48, 209, 88) },
		{ Text = "v1.0", Color = Color3.fromRGB(10, 132, 255) },
		{ Text = "Monochrome", Color = Color3.fromRGB(120, 120, 130) },
	})
	s:Paragraph({
		Title = "About",
		Content = "This file is a live demo of every element in the library. Switch tabs on the left to explore controls, data views, the theme editor and system tools.",
	})

	local q = Home:Section({ Title = "Quick actions", Icon = "zap" })
	q:ButtonGroup({ Buttons = {
		{ Title = "Notify", Variant = "Primary", Callback = function() Window:Notify({ Title = "Hello!", Content = "This is a notification.", Type = "Info", Icon = "info" }) end },
		{ Title = "Dialog", Callback = function() Window:Dialog({ Title = "Confirm", Content = "Do you like XexerUI?", Buttons = { { Title = "No" }, { Title = "Yes", Variant = "Primary", Callback = function() Window:Notify({ Title = "Nice.", Type = "Success", Icon = "check" }) end } } }) end },
		{ Title = "Prompt", Callback = function() Window:Prompt({ Title = "Say something", Placeholder = "type here...", Callback = function(t) Window:Notify({ Title = "You said", Content = tostring(t), Type = "Info", Icon = "message-square" }) end }) end },
	} })

	local grid = Home:Section({ Title = "Live stats", Icon = "activity" })
	grid:StatGrid({
		{ Label = "Players", Value = #Players:GetPlayers(), Icon = "users" },
		{ Label = "Place Id", Value = tostring(game.PlaceId), Icon = "map-pin" },
		{ Label = "Executor", Value = (identifyexecutor and identifyexecutor()) or "Unknown", Icon = "terminal" },
		{ Label = "FPS", Value = "--", Icon = "gauge" },
	})
	local luc = 0
	grid:Stats({
		Interval = 1,
		Items = {
			{ Label = "Uptime", Icon = "clock", Get = function() return math.floor(os.clock()) end, Suffix = "s" },
			{ Label = "Tick", Icon = "activity", Get = function() return os.clock() end, Format = "raw", Rate = true },
		},
	})
end

-- ============================================================
--  TAB 2 — CONTROLS
-- ============================================================
local Ctrl = Window:Tab({ Title = "Controls", Icon = "sliders-horizontal" })
do
	local s = Ctrl:Section({ Title = "Booleans", Icon = "toggle-left" })
	local ro = s:Toggle({ Title = "Master toggle", Description = "switch-style on / off", Default = true, Tooltip = "This is a toggle", Callback = function(v) end })
	s:Toggle({ Title = "Depends on master", Description = "only enabled when master is on", DependsOn = ro, Callback = function() end })
	s:Toggle({ Title = "Auto-off (3s)", Description = "flips itself back off", AutoOff = 3, Callback = function() end })
	s:Checkbox({ Title = "Checkbox", Description = "square check", Default = true, Callback = function(v) end })
	s:Radio({ Title = "Radio group", Options = { "Option A", "Option B", "Option C" }, Default = "Option A", Callback = function(v) end })
	s:Segmented({ Title = "Segmented", Options = { "Low", "Medium", "High" }, Default = "Medium", Callback = function(v) end })

	local n = Ctrl:Section({ Title = "Numbers", Icon = "hash" })
	n:Slider({ Title = "Slider", Description = "0 - 100", Min = 0, Max = 100, Default = 40, Suffix = "%", Callback = function(v) end })
	n:Slider({ Title = "Rounded slider", Min = 0, Max = 1, Default = 0.5, Rounding = 0.01, Callback = function(v) end })
	n:NumberInput({ Title = "Number input", Description = "with +/- stepper", Default = 5, Min = 0, Max = 100, Step = 1, Callback = function(v) end })
	n:Stepper({ Title = "Stepper (alias)", Default = 1, Step = 5, Callback = function(v) end })

	local t = Ctrl:Section({ Title = "Text & keys", Icon = "type" })
	t:Textbox({ Title = "Textbox", Placeholder = "type and press enter...", Callback = function(v) Window:Notify({ Title = "Textbox", Content = tostring(v), Type = "Info", Icon = "type" }) end })
	t:Textarea({ Title = "Textarea", Placeholder = "multi-line...", Height = 80, Callback = function(v) end })
	t:Keybind({ Title = "Keybind", Description = "click, then press a key", Default = Enum.KeyCode.F, Callback = function() Window:Notify({ Title = "Keybind", Content = "triggered", Type = "Info", Icon = "keyboard" }) end })
	t:ColorPicker({ Title = "Color picker", Default = Color3.fromRGB(255, 121, 198), Callback = function(c) end })

	local d = Ctrl:Section({ Title = "Choice", Icon = "list" })
	d:Dropdown({ Title = "Dropdown", Options = { "Apple", "Banana", "Cherry" }, Default = "Apple", Callback = function(v) end })
	d:Dropdown({ Title = "Icons", Options = { "Home", "Settings", "User" }, Icons = { Home = "home", Settings = "settings", User = "user" }, Callback = function(v) end })
	d:Dropdown({ Title = "Multi-select", Multi = true, Options = { "A", "B", "C", "D" }, Callback = function(v) end })
	d:Dropdown({ Title = "Searchable", Options = { "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight" }, Callback = function(v) end })
end

-- ============================================================
--  TAB 3 — DATA
-- ============================================================
local Data = Window:Tab({ Title = "Data", Icon = "database" })
do
	local g = Data:Section({ Title = "Graph", Icon = "trending-up" })
	local wave = 0
	local gr = g:Graph({ Title = "Sine wave", Height = 90, Min = -1, Max = 1, Suffix = "", Points = 60 })
	task.spawn(function()
		while gr and task.wait(0.1) do
			wave = wave + 0.2
			gr:Push(math.sin(wave))
		end
	end)

	local p = Data:Section({ Title = "Progress", Icon = "loader" })
	local pr = p:Progress({ Title = "Loading", Default = 0 })
	task.spawn(function()
		local v = 0
		while task.wait(0.15) do
			v = v + 0.02
			if v > 1 then v = 0 end
			pr:Set(v)
		end
	end)

	local s = Data:Section({ Title = "Stats grid", Icon = "bar-chart-3" })
	s:StatGrid({
		{ Label = "Score", Value = 1234, Icon = "star" },
		{ Label = "Rank", Value = "A+", Icon = "award" },
	})

	local tb = Data:Section({ Title = "Table", Icon = "table" })
	tb:Table({
		Title = "Click a header to sort",
		Columns = { "Name", "Level", "Score" },
		Rows = {
			{ "Alice", 12, 3400 },
			{ "Bob", 8, 1900 },
			{ "Cara", 20, 7200 },
			{ "Dan", 3, 450 },
		},
		Callback = function(row) end,
	})

	local m = Data:Section({ Title = "Media & text", Icon = "image" })
	m:Image({ Height = 110, Image = "rbxassetid://0" })
	m:Divider("section divider")
	m:Divider()
	m:Label("A plain wrapped label. Useful for notes, tips and small descriptions that flow with the layout.")
	m:CodeBlock({ Title = "Luau", Code = 'local x = 1\nprint("hello, XexerUI")\nreturn x * 2' })
end

-- ============================================================
--  TAB 4 — SYSTEM
-- ============================================================
local Sys = Window:Tab({ Title = "System", Icon = "settings" })
do
	local s = Sys:Section({ Title = "System info", Icon = "gauge" })
	s:SystemInfo({ Icons = { FPS = "gauge", Ping = "wifi", Executor = "terminal", Players = "users", Game = "gamepad-2", Time = "clock" } })

	local w = Sys:Section({ Title = "Hardware id", Icon = "cpu" })
	w:HWID({ Callback = function(id) end })

	local pl = Sys:Section({ Title = "Live lists", Icon = "users" })
	pl:PlayerDropdown({ Title = "Player", IncludeNone = true, Callback = function(v) end })
	pl:TeamDropdown({ Title = "Team", Callback = function(v) end })

	local c = Sys:Section({ Title = "Configuration", Icon = "save" })
	c:ConfigManager()
end

-- ============================================================
--  TAB 5 — THEME
-- ============================================================
local ThemeTab = Window:Tab({ Title = "Theme", Icon = "palette" })
do
	local s = ThemeTab:Section({ Title = "Presets", Icon = "swatch-book" })
	s:ButtonGroup({ Buttons = {
		{ Title = "Dark", Variant = "Primary", Callback = function() Window:SetTheme("Dark") end },
		{ Title = "Midnight", Callback = function() Window:SetTheme("Midnight") end },
		{ Title = "Light", Callback = function() Window:SetTheme("Light") end },
		{ Title = "Mono", Callback = function() Window:SetTheme("Mono") end },
	} })

	local a = ThemeTab:Section({ Title = "Accent", Icon = "paint-bucket" })
	a:ButtonGroup({ Buttons = {
		{ Title = "Pink", Variant = "Primary", Callback = function() Window:SetAccent("Pink") end },
		{ Title = "Blue", Callback = function() Window:SetAccent("Blue") end },
		{ Title = "Green", Callback = function() Window:SetAccent("Green") end },
		{ Title = "Purple", Callback = function() Window:SetAccent("Purple") end },
	} })
	a:ButtonGroup({ Buttons = {
		{ Title = "Orange", Callback = function() Window:SetAccent("Orange") end },
		{ Title = "Red", Callback = function() Window:SetAccent("Red") end },
		{ Title = "White", Callback = function() Window:SetAccent("White") end },
	} })
	a:Toggle({ Title = "Rainbow accent", Description = "animated hue cycle", Callback = function(v)
		Window:RainbowAccent(v and true or false)
	end })

	local e = ThemeTab:Section({ Title = "Editor", Icon = "sliders-horizontal" })
	e:ThemeEditor()

	local h = ThemeTab:Section({ Title = "Watermark & loading", Icon = "monitor" })
	local wm
	h:ButtonGroup({ Buttons = {
		{ Title = "Toggle watermark", Variant = "Primary", Callback = function()
			if wm then wm.Destroy(); wm = nil else wm = Window:Watermark({ Text = "XexerUI" }) end
		end },
		{ Title = "Show loading", Callback = function()
			local l = Window:Loading({ Title = "Please wait", SubTitle = "Loading demo..." })
			task.delay(2.5, function() l.Close() end)
		end },
	} })
end

-- ============================================================
--  OPEN
-- ============================================================
Window:Notify({ Title = "Welcome to XexerUI", Content = "Press Ctrl/Cmd+K for Spotlight.", Type = "Info", Icon = "sparkles", Duration = 6 })
