# Snowfall UI

A lightweight drawing-based UI library for Roblox executors.

## Usage

Load the library and pass your own settings. Every field is optional; remove a
field to use the library's default.

```lua
local config = {
    ["name"] = "Snowfall",
    ["version"] = "1.0",
    ["ui_scale"] = 1.50,
    -- ["logo"] = "my_logo.png",         -- workspace image path
    -- ["logo_data"] = raw_image_bytes,  -- or pass the bytes directly
    -- ["logo_is_asset"] = false,        -- true loads ["logo"] via getcustomasset
    -- ["folder"] = "juju recode",       -- folder for assets/ and data.dat
}

local library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/hevji/snowfall-ui/main/ui.lua"
))(config)

local menu = library.menu
local flags = library.flags
```

| Field | Default | Purpose |
| --- | --- | --- |
| `name` | `"Snowfall"` | name shown in the header |
| `version` | `"1.0"` | version shown in the header |
| `ui_scale` | `1.50` | overall menu scale |
| `logo` | bundled logo | workspace path for a custom logo |
| `logo_data` | `nil` | raw image bytes (takes priority over `logo`) |
| `logo_is_asset` | `false` | load `logo` with `getcustomasset` |
| `folder` | `"juju recode"` | folder containing `assets/` and `data.dat` |

## Example

[`example.lua`](example.lua) is a complete menu showing every element type:
toggle, slider, dropdown, textbox, colorpicker, keybind, button and info.

## Notes

- Branding is supplied by the loading script, not `getgenv()`, so it cannot be
  overwritten by other scripts.
- The header name/version shrink and truncate to stay inside the sidebar, and
  element labels truncate instead of overlapping their right-side controls.
- Missing assets are downloaded automatically on first run into `folder`.
