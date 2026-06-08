local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()
local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")

config.color_scheme = "Tokyo Night"
bar.apply_to_config(config, {
	padding = {
		tabs = {
			left = 1,
			right = 1,
		},
	},
})

config.font = wezterm.font("JetBrainsMono Nerd Font")
config.enable_tab_bar = true
config.tab_bar_at_bottom = true
config.window_decorations = "RESIZE"
config.window_close_confirmation = "NeverPrompt"
config.enable_wayland = true

config.colors = {
	background = "black", -- Or use #000000 or {h = 0, s = 0, b = 0}
	tab_bar = {
		background = "rgba(0,0,0,0)",
		active_tab = {
			fg_color = "rgba(0,0,0,1)",
			bg_color = "rgb(102, 132, 197)",
		},
		inactive_tab = {
			bg_color = "rgba(0,0,0,0)",
			fg_color = "rgb(102, 132, 197)",
		},
		new_tab = {
			bg_color = "rgba(0,0,0,0)",
			fg_color = "rgb(102, 132, 197)",
		},
	},
}

config.window_background_opacity = 0.7

config.window_padding = {
	-- left = 0,
	-- right = 0,

	bottom = 0,
}

config.use_fancy_tab_bar = false

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
	{ key = "a", mods = "LEADER|CTRL", action = act.SendKey({ key = "a", mods = "CTRL" }) },
	{ key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = false }) },
	{ key = "-", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "=", mods = "LEADER", action = act.Multiple({ act.SplitVertical({ domain = "CurrentPaneDomain" }) }) },
	{ key = "-", mods = "LEADER|CTRL", action = act.AdjustPaneSize({ "Down", 2 }) },
	{ key = "=", mods = "LEADER|CTRL", action = act.AdjustPaneSize({ "Up", 2 }) },
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{
		key = "t",
		mods = "LEADER",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
}

return config
