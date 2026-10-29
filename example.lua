-- Snowfall UI example
-- Run in a Roblox executor environment with the required Drawing/filesystem APIs.

local LIBRARY_URL = "https://raw.githubusercontent.com/hevji/snowfall-ui/main/library.lua"
local request_ok, source = pcall(function()
	return game:HttpGet(LIBRARY_URL)
end)
assert(request_ok and type(source) == "string", "Could not download Snowfall UI: " .. tostring(source))
assert(type(loadstring) == "function", "This executor does not provide loadstring")

local loader, compile_error = loadstring(source)
assert(type(loader) == "function", "Could not compile library.lua: " .. tostring(compile_error))

local library = loader()
assert(type(library) == "table", "library.lua loaded but did not return its API table")
local menu = library.menu
local flags = library.flags

local showcase = menu.create_group("Showcase")
local basics = showcase:create_tab("Basics")

local general = basics:create_subtab("General")
local controls = general:create_section("Controls", 1, 1)
local inputs = general:create_section("Inputs", 2, 1)

local enabled = controls:create_element({ name = "Enable feature" }, {
	toggle = {
		flag = "example.enabled",
		default = true,
	},
	keybind = {
		default = Enum.KeyCode.G,
	},
})

local speed = controls:create_element({ name = "Speed" }, {
	slider = {
		flag = "example.speed",
		min = 0,
		max = 100,
		default = 50,
		decimals = 0,
		suffix = "%",
	},
})

local mode = inputs:create_element({ name = "Mode" }, {
	dropdown = {
		flag = "example.mode",
		options = { "Low", "Medium", "High" },
		default = { "Medium" },
	},
})

local username = inputs:create_element({ name = "Username" }, {
	textbox = {
		flag = "example.username",
		default = "Player",
	},
})

local notify = inputs:create_element({ name = "Show notification" }, {
	button = {},
})

local appearance = basics:create_subtab("Appearance")
local colors = appearance:create_section("Colors", 1, 1)
local accent = colors:create_element({ name = "Accent color" }, {
	colorpicker = {
		color_flag = "example.accent",
		transparency_flag = "example.accent_transparency",
		default_color = Color3.fromRGB(153, 216, 222),
		default_transparency = 0,
	},
})

library.create_connection(enabled.on_toggle_change, function(value)
	print("feature enabled:", value)
end)

library.create_connection(speed.on_slider_change, function(value)
	print("speed changed:", value)
end)

library.create_connection(mode.on_dropdown_change, function(selection)
	print("mode:", selection[1])
end)

library.create_connection(username.on_textbox_change, function(value)
	print("username:", value)
end)

library.create_connection(notify.on_clicked, function()
	menu.new_notification("Snowfall UI is ready", 1, 2)
end)

library.create_connection(accent.on_color_change, function(color)
	menu.set_accent_color(color)
end)

-- Current values are available through flags, for example:
print("initial speed:", flags["example.speed"])
