# Snowfall UI

Snowfall UI is a drawing-based Roblox interface library with a Lithium-inspired dark theme, smooth interactions, and a small API for building tabs, sections, controls, and configuration panels.

## Quick start

Run this in an environment that supports the Drawing API and the filesystem and executor functions used by `library.lua`:

```lua
local url = "https://raw.githubusercontent.com/hevji/snowfall-ui/main/library.lua"
local source = game:HttpGet(url)
local loader, compile_error = loadstring(source)
assert(loader, "Could not compile library.lua: " .. tostring(compile_error))
local library = loader()
assert(type(library) == "table", "library.lua did not return its API table")

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

- 125% default UI scale, draggable window, and bottom-right resize grip. The initial window is about 913×675 pixels at that scale.
- Groups, tabs, optional subtabs, and responsive two-column sections.
- Toggle, slider, dropdown, textbox, color picker, keybind, info, and button controls.
- Right-click keybind modes (toggle, hold, always, remove), an active keybind list, and customizable header text/logo.
- RightShift menu toggle by default, temporary first-person mouse unlock, and high-priority input capture over the UI.
- Signals, notifications, themes, configs, favorites, settings popovers, and keybind display.
- A dark teal palette, Plex font, glass-like translucent surfaces with soft scene blur, accent glows beneath dividers, a left-to-right fade on group heading lines, solid subtab underlines, and a refined resize grip.

`addons/SaveManager.luau` adds a `SaveManager` group and config tab. Install it under `<custom_folder>/addons/SaveManager.luau`, then run `menu:load_addon("SaveManager")`. For inline setup, `menu:setup_configs("SaveManager")` creates the same config interface.

The library automatically prepares its bundled assets and data under `getgenv().custom_folder` or `juju recode`.
