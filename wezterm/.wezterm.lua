-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action
-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = "Catppuccin Macchiato"
-- config.default_prog = { 'powershell.exe', '-NoLogo' }
config.default_domain = 'WSL:Ubuntu'
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.enable_tab_bar = false
config.window_decorations = "RESIZE"

local wsl_domains = wezterm.default_wsl_domains()

for _, dom in ipairs(wsl_domains) do
  dom.default_cwd = "/mnt/d"
end

config.colors = {
    background = 'black'  -- Or use #000000 or {h = 0, s = 0, b = 0}
}

config.wsl_domains = wsl_domains
-- config.default_cwd = "~/mnt/d"

-- config.background = {
--   {
--     source = {
--       File = "D:/wezterm/flatppuccin_4k_macchiato.png"
--     },
--   },
-- }


config.window_background_opacity = 0.7

-- config.background = {
--   {
--     source = {
--       File = "D:/wezterm/neon.png",
--     },
--     hsb = {
--       hue = 1.0,
--       saturation = 1.02,
--       brightness = 0.1,
--     },
--     -- attachment = { Parallax = 0.3 },
--     -- width = "100%",
--     -- height = "100%",
--   },
--   -- {
--   --   source = {
--   --     Color = "#282c35",
--   --   },
--   --   width = "100%",
--   --   height = "100%",
--   --   opacity = 0.55,
--   -- },
-- }

config.window_padding = {
  -- left = 0,
  -- right = 0,

  bottom = 0
}

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
  { key = "a", mods = "LEADER|CTRL", action = act.SendKey { key = "a", mods = "CTRL" } },
  { key = "-", mods = "LEADER", action = act.SplitHorizontal { domain = "CurrentPaneDomain" } }, 
  { key = "=", mods = "LEADER", action = act.Multiple { act.SplitVertical { domain = "CurrentPaneDomain" }, } },
  { key = "-", mods = "LEADER|CTRL", action = act.AdjustPaneSize { 'Down', 2 }, },
  { key = "=", mods = "LEADER|CTRL", action = act.AdjustPaneSize { 'Up', 2 }, },
  { key = "h",          mods = "LEADER", action = act.ActivatePaneDirection("Left") },
  { key = "l",          mods = "LEADER", action = act.ActivatePaneDirection("Right") },
  { key = "j",          mods = "LEADER", action = act.ActivatePaneDirection("Down") },
  { key = "k",          mods = "LEADER", action = act.ActivatePaneDirection("Up") },
{
    key = 'p',
    mods = 'LEADER',
    action = act.SpawnCommandInNewTab {
      args = { 'powershell.exe' },
      -- this is normally the default, but I'd recommend making it explicit
      -- when working on windows with WSL and other mux domains.
      -- This ensures that the command will be run on the wezterm GUI host
      -- and not in some other domain
      domain = { DomainName = 'local' }, 
    },
  },
{
    key = 't',
    mods = 'LEADER',
    action = act.SpawnTab 'CurrentPaneDomain',
    },
}

wezterm.on("gui-startup", function(cmd)
  local screen = wezterm.gui.screens().main
  local ratio = 0.9
  local width, height = screen.width * ratio / 1.07, screen.height * ratio / 1.13
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {
    position = { x = (screen.width - width) / 2, y = (screen.height - height) / 3.5 },
  })
  -- window:gui_window():maximize()
  window:gui_window():set_inner_size(width, height)
end) -- config.window_background_opacity = 0.8
-- and finally, return the configuration to wezterm

return config
