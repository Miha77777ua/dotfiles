require("vis")
local lspc = require("plugins/vis-lspc")
require("plugins/vis-autoclose")
require("plugins/vis-commentary")()

function read_template(name)
	local path = os.getenv("HOME") .. "/.config/vis/templates/" .. name
	local f = io.open(path, "r")

	if not f then
		return false
	end

	local text = f:read("*a")
	f:close()

	return text
end

vis.events.subscribe(vis.events.INIT, function()
	vis:map(vis.modes.NORMAL, " d", ":lspc-show-diagnostics<Enter>")
	vis:map(vis.modes.NORMAL, " e", function()
		vis:command("open .")
		vis:feedkeys("<C-w>j:wq!<Enter>")
		return 0
	end)
	vis:command_register("html", function()
		local text = read_template("skeleton.html")

		if not text then
			vis:info("skeleton not found: " .. text)
			return false
		end

		vis:insert(text)
		return true
	end)
end)

vis.events.subscribe(vis.events.WIN_OPEN, function()
	vis:command("set theme gruvbox")
	vis:command("set tabwidth 2")
	vis:command("set rnu true")
	vis:command("set ai true")
end)

lspc.ls_map.html = {
	name = "emmet-language-server",
	cmd = "emmet-language-server --stdio",
}
