# Snowfall UI documentation

Snowfall UI is a drawing-based Roblox UI library. It creates the window, input handling, controls, animation loop, notifications, themes, and configuration helpers. It is intended for environments that provide Roblox `Drawing`, `getgenv`, `gethui`, `cloneref`, `base64_decode`, and filesystem functions such as `readfile`, `writefile`, `isfile`, and `makefolder`. It is not a Roblox Studio `ScreenGui` library.

## Load the library

```lua
local source = game:HttpGet("https://raw.githubusercontent.com/hevji/snowfall-ui/main/library.lua")
local loader, compile_error = loadstring(source)
assert(loader, "Could not compile library.lua: " .. tostring(compile_error))
local library = loader()
assert(type(library) == "table", "library.lua did not return its API table")
local menu = library.menu
local flags = library.flags
```

The UI defaults to 125% scale (`menu.ui_scale == 1.25`) and an initial window size of about 913×675 pixels. Drag the header to move it and drag the bottom-right grip to resize its width and height. Resizing does not change the scale factor. The window uses a dark teal palette, Plex text, glass-like translucent surfaces with a subtle scene blur while open, softer rounded outlines, accent glows, one bright divider under the logo and title, and a rounded resize grip.

## Build the navigation

Create a group, then add one or more tabs. Tabs can contain normal sections or optional subtabs. Each subtab can own one or more sections; selecting a subtab hides the sections belonging to the others.

```lua
local group = menu.create_group("Showcase")
local tab = group:create_tab("Basics")

local general = tab:create_subtab("General")
local controls = general:create_section("Controls", 1, 1)
local appearance = tab:create_subtab("Appearance")
local colors = appearance:create_section("Colors", 1, 1)
```

`subtab:create_section(name, side, height, y_position)` uses the same section layout as `group:create_section(tab_name, name, side, height, y_position)`. `side` is `1` or `2`; `height` is the fraction of the available content area to occupy. Subtab sections fit below the subtab strip and remain inside the tab frame. Subtab underlines match the label width and stay solid; the active label and underline use the accent color with a soft glow just beneath the line, while inactive underlines stay subdued. Switching subtabs animates their section panels. The line under each `menu.create_group(...)` heading fades from left to right.

For a classic tab without subtabs:

```lua
local tab = group:create_tab("Main")
local left = group:create_section("Main", "General", 1, 0.48, 0)
local right = group:create_section("Main", "Extras", 2, 0.48, 0)
```

Create groups and tabs before their sections. `group:hide()` and `group:show()` hide or restore a group in the sidebar. `group:remove_tab(name)` removes a tab.

## Controls

Add controls with `section:create_element(info, controls)`. `info.name` is the visible label. `controls` is a table containing one control type and its options.

| Control key | Common options | Element methods and signals |
| --- | --- | --- |
| `toggle` | `flag`, `default` | `set_toggle(value)`, `on_toggle_change` |
| `slider` | `flag`, `min`, `max`, `default`, `decimals`, `prefix`, `suffix`, `min_text`, `max_text` | `set_slider(value)`, `on_slider_change` |
| `dropdown` | `flag`, `options`, `default` (array), `multi`, `requires_one` | `set_dropdown(value)`, `set_options(options)`, `on_dropdown_change` |
| `textbox` | `flag`, `default` | `set_textbox(value)`, `on_textbox_change` |
| `colorpicker` | `color_flag`, `transparency_flag`, `default_color`, `default_transparency` | `set_colorpicker(color)`, `set_colorpicker_transparency(value)`, `on_color_change`, `on_transparency_change` |
| `keybind` | `default` (`Enum.KeyCode`) and optional `flag` | `set_key(key)`, `on_key_change`, `on_key_press` |
| `button` | optional `confirmation`, `fake` | `on_clicked` |
| `info` | no options required | `set_info(property, value)` |

Every control with a `flag` stores its current value in `library.flags[flag]`. Toggles use a solid accent fill while enabled. Sliders support whole and decimal values, prefixes and suffixes, and min/max display text. Dropdown defaults are arrays even for a single choice; set `multi = true` to allow multiple selections. A color picker can store color and transparency under separate flags.

Example control declarations:

```lua
local enabled = controls:create_element({ name = "Enable feature" }, {
    toggle = { flag = "demo.enabled", default = false },
})

local speed = controls:create_element({ name = "Speed" }, {
    slider = {
        flag = "demo.speed", min = 0, max = 100, default = 50,
        decimals = 0, suffix = "%",
    },
})

local mode = controls:create_element({ name = "Mode" }, {
    dropdown = {
        flag = "demo.mode", options = { "Low", "Medium", "High" },
        default = { "Medium" },
    },
})
```

Elements can be hidden or shown with `element:set_visible(boolean)` and removed with `element:remove()`. `element:set_name(text)` or `element:set_text(text)` changes the visible label, including its keybind-list label. Elements may include `tip` text in their `info` table.

### Keybind assignment and modes

Give a control a keybind field with a flag and a default key. Right-click that assigned key box to attach the control action to it. After it is attached, right-click the assigned key box to choose **toggle**, **hold**, **always**, or **remove keybind**. Unassigned controls do not open this keybind menu.

```lua
local enabled = controls:create_element({ name = "Enable feature" }, {
    toggle = { flag = "demo.enabled", default = false },
    keybind = { flag = "demo.enabled_key", default = Enum.KeyCode.G },
})
```

The keybind list tracks active binds even while hidden. Enable “keybinds list” in menu settings or call `menu:show_keybinds()` to display it. Toggle and hold entries appear while active; always entries remain listed. Call `menu:hide_keybinds()` to hide the list.

## Events and helpers

Signals are connected through the library helper so connections are cleaned up when the menu unloads:

```lua
library.create_connection(enabled.on_toggle_change, function(value)
    print("enabled:", value)
end)

library.create_connection(speed.on_slider_change, function(value)
    print("speed:", value)
end)
```

Buttons expose `on_clicked`; toggles, sliders, dropdowns, textboxes, color pickers, and keybinds expose the signals listed above. A signal also supports `:Connect(callback)` and `:Fire(...)`.

Other returned helpers include `library.tween(object, properties, easing_style, easing_direction, duration)`, `library.create_instance(class, properties)`, `library.round(number, decimals)`, and `library.remove(array, index)`. `library.drawing` exposes the selected Drawing implementation; `library.drawing_proxy` exposes its managed proxy. `library.connections`, `library.heartbeat`, `library.addon_data`, and `library.menu_references` are exposed for integrations.

## Notifications, themes, configs, and keybinds

- `menu.new_notification(text, type, duration)` displays a notification. Types `1`, `2`, and `3` represent success, alert, and error.
- `menu.set_accent_color(color3)` changes the accent at runtime.
- `menu:set_text(title, subtitle)` changes the header labels. `menu:set_branding({ title = ..., subtitle = ..., logo = ... })` sets both labels and an optional local logo path.
- `menu:set_logo(path)` loads a local image through `getcustomasset`; paths can be absolute or relative to the library asset folder. Set `getgenv().script_name`, `getgenv().script_version`, and `getgenv().script_logo` before loading to set initial branding.
- `menu:show_keybinds()` and `menu:hide_keybinds()` show or hide the active keybind list.
- `menu:setup_configs(group_or_name)` adds a config group and `configs` tab with create, load, update, delete, and refresh actions. It returns the config list, info, and editor sections. Config data is stored under the configured folder.
- `addons/SaveManager.luau` is the SaveManager addon. Copy it to `<custom_folder>/addons/SaveManager.luau` (default: `juju recode/addons/SaveManager.luau`), then call `menu:load_addon("SaveManager")`. It creates a `SaveManager` group with a config tab and removes the group when unloaded. Use the addon or call `menu:setup_configs(...)` directly, not both with the same group name.
- Themes can be selected and managed from the built-in settings interface. `menu:load_theme(name)` loads a theme; `menu.get_theme_list()` returns available theme names.
- `menu.save_config(name)`, `menu.load_config(name)`, `menu.get_config_list()`, and `menu.get_config_data(data)` provide config helpers.
- The library stores notification preference, autoload config, favorites, theme selection, and hide-on-load preference in `data.dat`.
- Unload the menu and disconnect its input/render hooks with `getgenv()._JUJU()`. The original Roblox mouse cursor visibility is restored during unload.

## Complete example

Run [`example.lua`](example.lua) after placing the library at the documented raw GitHub URL, or change its `LIBRARY_URL` to the location you use.
