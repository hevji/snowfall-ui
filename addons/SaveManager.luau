-- SaveManager addon for Snowfall UI.
-- Install this file as <custom_folder>/addons/SaveManager.luau, then call:
-- menu:load_addon("SaveManager")

local manager = menu.create_group("SaveManager")
menu:setup_configs(manager)

local addon = addon_data[__IDENTIFIER]
if addon then
	addon[2] = manager
end
