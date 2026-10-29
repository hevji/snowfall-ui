--[[
	Snowfall UI - example.lua

	This is a small example menu that shows the most common element types.
	Place this file next to ui.lua in your executor's workspace folder, then run it.

	All options below are passed to the library by this script, so ui.lua never
	has to be edited. Remove any field to use the library's default.
]]

-- Options for the loader. Everything here is optional:
--   ["name"] / ["version"]  name and version shown in the top-left corner
--   ["ui_scale"]            overall menu size (1.25 = 125%)
--   ["logo"]                workspace file path used as the menu logo
--   ["logo_data"]           raw image bytes, used instead of ["logo"]
--   ["logo_is_asset"]       true loads ["logo"] through getcustomasset
--   ["folder"]              folder containing assets/ and data.dat
local config = {
	["name"] = "Snowfall",
	["version"] = "1.0",
	["ui_scale"] = 1.50,
	-- ["logo"] = "my_logo.png",
	-- ["folder"] = "juju recode",
}

-- Load the library straight from GitHub.
-- (Use readfile("ui.lua") instead if you prefer to run a local copy.)
local UI_URL = "https://raw.githubusercontent.com/hevji/snowfall-ui/main/ui.lua"
local library = loadstring(game:HttpGet(UI_URL))(config)
local menu = library.menu
local flags = library.flags

-- Optional: change the accent color used across the UI.
menu.set_accent_color(Color3.fromRGB(154, 213, 222))

-- Create a group (the list on the left) and a tab inside it.
local group = menu.create_group("Example")
local tab = group:create_tab("Main")

-- A tab can have a left and a right section.
-- create_section(tab_name, name, side, height, y_position)
--   side 1 = left half, side 2 = right half
--   height / y_position are fractions of the tab height (0 - 1)
local general = group:create_section("Main", "General", 1, 1, 0)
local extras = group:create_section("Main", "Extras", 2, 1, 0)

-- Toggle ---------------------------------------------------------------------

local enabled = general:create_element({
	["name"] = "Enable feature",
}, {
	["toggle"] = {
		["flag"] = "example_enabled",
		["default"] = false,
	},
})

enabled.on_toggle_change:Connect(function(value)
	print("example_enabled:", value)
end)

-- Slider ---------------------------------------------------------------------

local speed = general:create_element({
	["name"] = "Speed",
}, {
	["slider"] = {
		["flag"] = "example_speed",
		["min"] = 0,
		["max"] = 100,
		["default"] = 50,
		["suffix"] = "%",
		["decimals"] = 0,
	},
})

speed.on_slider_change:Connect(function(value)
	print("example_speed:", value)
end)

-- Dropdown -------------------------------------------------------------------

local mode = general:create_element({
	["name"] = "Mode",
}, {
	["dropdown"] = {
		["flag"] = "example_mode",
		["options"] = { "Low", "Medium", "High" },
		["default"] = "Medium",
	},
})

mode.on_dropdown_change:Connect(function(value)
	print("example_mode:", value)
end)

-- Textbox --------------------------------------------------------------------

local username = general:create_element({
	["name"] = "Username",
}, {
	["textbox"] = {
		["flag"] = "example_username",
		["default"] = "Player",
	},
})

username.on_textbox_change:Connect(function(value)
	print("example_username:", value)
end)

-- Color picker ---------------------------------------------------------------

local accent = extras:create_element({
	["name"] = "Accent color",
}, {
	["colorpicker"] = {
		["color_flag"] = "example_accent",
		["transparency_flag"] = "example_accent_transparency",
		["default_color"] = Color3.fromRGB(154, 213, 222),
		["default_transparency"] = 0,
	},
})

accent.on_color_change:Connect(function(color)
	print("example_accent:", color)
end)

-- Keybind --------------------------------------------------------------------

local keybind = extras:create_element({
	["name"] = "Toggle keybind",
}, {
	["keybind"] = {
		["flag"] = "example_keybind",
		["default"] = Enum.KeyCode.RightShift,
	},
})

keybind:set_key(Enum.KeyCode.RightShift)

keybind.on_key_change:Connect(function(key)
	print("example_keybind:", key)
end)

-- Button ---------------------------------------------------------------------

local notify = extras:create_element({
	["name"] = "Show notification",
}, {
	["button"] = {},
})

notify.on_clicked:Connect(function()
	menu.new_notification("Hello from example.lua!", 1)
end)

-- Info -----------------------------------------------------------------------

local version = extras:create_element({
	["name"] = "Version",
}, {
	["info"] = {},
})

version:set_info("Text", "example 1.0")

-- Flags are also updated while the menu is open.
print("Initial flag value:", flags["example_speed"])
