-- load standard vis module, providing parts of the Lua API
require("vis")
require("plugins/vis-autoclose")
require("plugins/vis-lspc")
require("plugins/vis-commentary")()

vis.events.subscribe(vis.events.INIT, function()
	-- Your global configuration options
	vis:map(vis.modes.NORMAL, " d", ":lspc-show-diagnostics<Enter>")
	vis:map(vis.modes.NORMAL, " e", function()
		vis:command("open .")
		vis:feedkeys("<C-w>j:wq!<Enter>")
		return 0
	end)
end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win) -- luacheck: no unused args
	-- Your per window configuration options e.g.
	-- vis:command("set number")
	vis:command("set theme gruvbox")
	vis:command("set tabwidth 2")
	vis:command("set rnu true")
end)
