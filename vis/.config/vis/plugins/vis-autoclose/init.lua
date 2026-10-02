require('vis')

local brackets = {
	["("] = "()",
	["{"] = "{}",
	["["] = "[]",
	["<"] = "<>",
	["'"] = "''",
	['"'] = '""',
	['`'] = '``',
};

local closed = {
	[")"] = "",
	["}"] = "",
	["]"] = "",
	[">"] = "",
	["'"] = "",
	['"'] = "",
	["`"] = "",
};

local remove = {
	["()"] = "",
	["{}"] = "",
	["[]"] = "",
	["<>"] = "",
	["''"] = "",
	['""'] = "",
	['``'] = "",
};

function is_bracket_or_empty(char)
	return 	char == ' ' or
		char == '\n' or
		brackets[char] ~= nil or
		closed[char] ~= nil
end

vis.events.subscribe(vis.events.INPUT, function(key)
	local file = vis.win.file
	local cursor = vis.win.selection.pos
	local next = file:content(cursor, 1)
	-- closed bracket already exists, skip
	if key == next and closed[next] ~= nil then
		vis:feedkeys('<Right>')
		return true
	end

	local result = brackets[key]
	if result ~= nil and is_bracket_or_empty(next) then
		vis:insert(result)
		vis:feedkeys('<Left>')
		return true
	end
	return false
end)

vis:map(vis.modes.INSERT, "<Backspace>", function(keys)
	local cursor = vis.win.selection.pos

	if cursor == 0 then
		return 1
	end

	local file = vis.win.file
	local prev = file:content(cursor-1, 2)

	-- Workaround until https://github.com/martanne/vis/issues/739 is solved
	vis:feedkeys("<Left>")
	-- Check if whole bracket pair is to be removed
	if prev ~= nil then
		local result = remove[prev]
		if result ~= nil then
			vis:feedkeys("<Delete>")
		end
	end

	vis:feedkeys("<Delete>")
	return 1
end, "Removes the previous character (and closed brackets, if empty)")
