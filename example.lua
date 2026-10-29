--[[
	Snowfall UI - showcase.lua

	Comprehensive example demonstrating every control type,
	multiple groups/tabs, risky toggles, separators, and
	rich‑text/info elements.
]]

-- -----------------------------------------------------------------------------
-- Loader configuration (all fields optional)
-- -----------------------------------------------------------------------------
local config = {
	["name"]        = "Snowfall",
	["version"]     = "1.0",
	["ui_scale"]    = 1.50,
	-- ["logo"]           = "my_logo.png",
	-- ["folder"]         = "juju recode",
}

-- -----------------------------------------------------------------------------
-- Load library from GitHub (fallback to jsDelivr)
-- -----------------------------------------------------------------------------
local UI_URLS = {
	"https://raw.githubusercontent.com/hevji/snowfall-ui/main/ui.lua",
	"https://cdn.jsdelivr.net/gh/hevji/snowfall-ui@main/ui.lua",
}

local http_get = game.HttpGet or game.HttpGetAsync
local compile  = loadstring or load

local function load_library()
	local last_error = "no source url available"
	if not http_get then error("snowfall ui failed to load: this executor has no HttpGet", 0) end
	if not compile  then error("snowfall ui failed to load: this executor has no loadstring", 0) end

	for _, url in ipairs(UI_URLS) do
		local ok, source = pcall(http_get, game, url)
		if not ok or type(source) ~= "string" or source == "" then
			last_error = "download failed: " .. tostring(source)
		else
			local chunk, compile_error = compile(source, "snowfall-ui")
			if not chunk then
				last_error = "compile error: " .. tostring(compile_error)
			else
				local success, result = pcall(chunk, config)
				if success and type(result) == "table" and result["menu"] then
					return result
				end
				last_error = success and "ui.lua did not return a library" or tostring(result)
			end
		end
	end
	error("snowfall ui failed to load: " .. tostring(last_error), 0)
end

local library = load_library()
local menu    = library.menu
local flags   = library.flags

-- -----------------------------------------------------------------------------
-- Global accent (can be overridden per‑section via colorpicker)
-- -----------------------------------------------------------------------------
menu.set_accent_color(Color3.fromRGB(0, 180, 180))   -- muted cyan/teal

-- -----------------------------------------------------------------------------
-- Helper: create a section with a header paragraph (info element) and a separator
-- -----------------------------------------------------------------------------
local function make_section(tab, name, side)
	local sec = tab:create_section(tab.name, name, side, 1, 0)
	-- optional: add a descriptive paragraph at top
	sec:create_element({
		["name"] = "About " .. name,
	}, { ["info"] = {} })
	sec:create_element({ ["name"] = "" }, { ["separator"] = {} })
	return sec
end

-- =============================================================================
-- GROUP 1 – MAIN
-- =============================================================================
local groupMain = menu.create_group("Main")
local tabGeneral = groupMain:create_tab("General")
local tabVisuals = groupMain:create_tab("Visuals")

-- ---- General tab -----------------------------------------------------------
local genLeft  = make_section(tabGeneral, "General", 1)
local genRight = make_section(tabGeneral, "Extras", 2)

-- Toggle (normal)
genLeft:create_element({
	["name"] = "Enable feature",
}, {
	["toggle"] = { ["flag"] = "ex_enable", ["default"] = false }
})

-- Risky toggle (red styling)
genLeft:create_element({
	["name"] = "Dangerous option (risky)",
}, {
	["toggle"] = { ["flag"] = "ex_danger", ["default"] = false, ["risky"] = true }
})

genLeft:create_element({ ["name"] = "" }, { ["separator"] = {} })

-- Slider with suffix and decimals
genLeft:create_element({
	["name"] = "Speed",
}, {
	["slider"] = {
		["flag"] = "ex_speed",
		["min"] = 0,
		["max"] = 100,
		["default"] = 50,
		["suffix"] = "%",
		["decimals"] = 1,
	}
})

-- Dropdown
genLeft:create_element({
	["name"] = "Mode",
}, {
	["dropdown"] = {
		["flag"] = "ex_mode",
		["options"] = { "Low", "Medium", "High", "Ultra" },
		["default"] = "Medium",
	}
})

-- Textbox
genRight:create_element({
	["name"] = "Username",
}, {
	["textbox"] = {
		["flag"] = "ex_user",
		["default"] = "Player",
	}
})

-- Color picker
genRight:create_element({
	["name"] = "Accent color",
}, {
	["colorpicker"] = {
		["color_flag"] = "ex_accent",
		["transparency_flag"] = "ex_accent_alpha",
		["default_color"] = Color3.fromRGB(0, 180, 180),
		["default_transparency"] = 0,
	}
})

-- Keybind
genRight:create_element({
	["name"] = "Toggle menu key",
}, {
	["keybind"] = {
		["flag"] = "ex_key",
		["default"] = Enum.KeyCode.RightShift,
	}
})

-- Button (notification)
genRight:create_element({
	["name"] = "Show notification",
}, {
	["button"] = {}
}).on_clicked:Connect(function()
	menu.new_notification("Hello from Snowfall showcase!", 2)
end)

-- Info / version label
genRight:create_element({
	["name"] = "Version",
}, {
	["info"] = {}
}):set_info("Text", "Snowfall UI 1.0 • showcase")

-- -----------------------------------------------------------------------------
-- ---- Visuals tab ------------------------------------------------------------
local visLeft  = make_section(tabVisuals, "Rendering", 1)
local visRight = make_section(tabVisuals, "Effects", 2)

visLeft:create_element({
	["name"] = "Enable ESP",
}, { ["toggle"] = { ["flag"] = "vis_esp", ["default"] = false } })

visLeft:create_element({
	["name"] = "Enable Chams (risky)",
}, { ["toggle"] = { ["flag"] = "vis_chams", ["default"] = false, ["risky"] = true } })

visLeft:create_element({ ["name"] = "" }, { ["separator"] = {} })

visLeft:create_element({
	["name"] = "ESP Distance",
}, {
	["slider"] = {
		["flag"] = "vis_dist",
		["min"] = 50,
		["max"] = 5000,
		["default"] = 2000,
		["suffix"] = " studs",
		["decimals"] = 0,
	}
})

visRight:create_element({
	["name"] = "Cham Material",
}, {
	["dropdown"] = {
		["flag"] = "vis_mat",
		["options"] = { "ForceField", "Neon", "Glass", "Plastic" },
		["default"] = "ForceField",
	}
})

visRight:create_element({
	["name"] = "Glow Intensity",
}, {
	["slider"] = {
		["flag"] = "vis_glow",
		["min"] = 0,
		["max"] = 1,
		["default"] = 0.4,
		["suffix"] = "",
		["decimals"] = 2,
	}
})

visRight:create_element({
	["name"] = "Custom Color",
}, {
	["colorpicker"] = {
		["color_flag"] = "vis_customcol",
		["transparency_flag"] = "vis_customalpha",
		["default_color"] = Color3.fromRGB(255, 100, 100),
		["default_transparency"] = 0.2,
	}
})

visRight:create_element({ ["name"] = "" }, { ["separator"] = {} })

visRight:create_element({
	["name"] = "Reset to defaults",
}, { ["button"] = {} }).on_clicked:Connect(function()
	flags["vis_esp"] = false
	flags["vis_chams"] = false
	flags["vis_dist"] = 2000
	flags["vis_mat"] = "ForceField"
	flags["vis_glow"] = 0.4
	menu.new_notification("Visuals reset to defaults", 1)
end)

-- =============================================================================
-- GROUP 2 – SETTINGS
-- =============================================================================
local groupSettings = menu.create_group("Settings")
local tabConfig = groupSettings:create_tab("Config")
local tabAbout  = groupSettings:create_tab("About")

local cfgLeft = make_section(tabConfig, "Persistence", 1)
local cfgRight = make_section(tabConfig, "Advanced", 2)

cfgLeft:create_element({
	["name"] = "Auto‑save config",
}, { ["toggle"] = { ["flag"] = "cfg_autosave", ["default"] = true } })

cfgLeft:create_element({
	["name"] = "Load last profile on start",
}, { ["toggle"] = { ["flag"] = "cfg_loadlast", ["default"] = true } })

cfgLeft:create_element({ ["name"] = "" }, { ["separator"] = {} })

cfgRight:create_element({
	["name"] = "Config folder name",
}, {
	["textbox"] = {
		["flag"] = "cfg_folder",
		["default"] = "SnowfallConfigs",
	}
})

cfgRight:create_element({
	["name"] = "Export config",
}, { ["button"] = {} }).on_clicked:Connect(function()
	menu.new_notification("Config exported (stub)", 1)
end)

cfgRight:create_element({
	["name"] = "Import config",
}, { ["button"] = {} }).on_clicked:Connect(function()
	menu.new_notification("Config imported (stub)", 1)
end)

-- ---- About tab -------------------------------------------------------------
local aboutLeft = make_section(tabAbout, "Info", 1)
local aboutRight = make_section(tabAbout, "Credits", 2)

aboutLeft:create_element({
	["name"] = "Library version",
}, { ["info"] = {} }):set_info("Text", "Snowfall UI v1.0")

aboutLeft:create_element({
	["name"] = "Author",
}, { ["info"] = {} }):set_info("Text", "hevji")

aboutLeft:create_element({
	["name"] = "License",
}, { ["info"] = {} }):set_info("Text", "MIT")

aboutRight:create_element({
	["name"] = "Special thanks",
}, { ["info"] = {} }):set_info("Text", "Lithium UI for visual inspiration\nRoblox drawing API community")

aboutRight:create_element({
	["name"] = "Open GitHub",
}, { ["button"] = {} }).on_clicked:Connect(function()
	menu.new_notification("https://github.com/hevji/snowfall-ui", 3)
end)

-- -----------------------------------------------------------------------------
-- Demo callbacks (print flag changes)
-- -----------------------------------------------------------------------------
local function watch(flag)
	local fn = function(v) print(flag .. " =", v) end
	if flags[flag] ~= nil then fn(flags[flag]) end
	-- The library fires signals on change; we can hook via element signals if needed
end

watch("ex_enable")
watch("ex_speed")
watch("ex_mode")
watch("vis_esp")
watch("vis_chams")

print("Showcase loaded – open the menu with the bound key (RightShift by default).")