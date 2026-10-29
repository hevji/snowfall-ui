# Snowfall UI

Snowfall UI is a drawing-based Roblox interface library with a Lithium-inspired dark theme, smooth interactions, and a small API for building tabs, sections, controls, and configuration panels.

## Quick start

Run this in an environment that supports the Drawing API and the filesystem and executor functions used by `library.lua`:

```lua
local url = "https://raw.githubusercontent.com/hevji/snowfall-ui/main/library.lua"
local library = loadstring(game:HttpGet(url))()

local menu = library.menu
local group = menu.create_group("Showcase")
local tab = group:create_tab("Basics")
local page = tab:create_subtab("General")
local controls = page:create_section("Controls", 1, 1)

local enabled = controls:create_element({ name = "Enabled" }, {
	toggle = { flag = "demo.enabled", default = true },
})
```

See [`example.lua`](example.lua) for a complete runnable menu and [`docs.md`](docs.md) for the feature and API reference.

## Included

- 125% default UI scale, draggable window, and bottom-right resize grip.
- Groups, tabs, optional subtabs, and responsive two-column sections.
- Toggle, slider, dropdown, textbox, color picker, keybind, info, and button controls.
- Signals, notifications, themes, configs, favorites, settings popovers, and keybind display.
- A dark teal palette, Plex font, translucent tinted surfaces, soft glow, and fading stripe accents.

The library automatically prepares its bundled assets and data under `getgenv().custom_folder` or `juju recode`.
