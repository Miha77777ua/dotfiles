--
-- vis-commentary
--

local vis = _G.vis
local M = {}

local comments_repl = {
    -- syntax = comment_line  OR  {L?=line, P?=prefix, S?=suffix}
    -- You MUST have either a prefix or line, else its an error
    actionscript='//',
    ada='--',
    ansi_c={P='/*',S='*/'},
    antlr='//',
    apdl='!',
    apl='#',
    applescript='--',
    asciidoc = '//',
    asp="'",
    autoit=';',
    awk='#',
    b_lang='//',
    bash='#',
    batch=':',
    bibtex='%',
    boo='#',
    chuck='//',
    cmake='#',
    coffeescript='#',
    context='%',
    c={P='/*',S='*/'},
    cpp='//',
    crystal='#',
    csharp='//',
    css = {P='/*',S='*/'},
    cuda='//',
    dart='//',
    desktop='#',
    django = {P='{#',S='#}'},
    dmd='//',
    dockerfile='#',
    dot='//',
    eiffel='--',
    elixir='#',
    erlang='%',
    faust='//',
    fennel=';;',
    fish='#',
    forth=[[\]],
    fortran='!',
    fsharp='//',
    gap='#',
    gettext='#',
    gherkin='#',
    glsl='//',
    gnuplot='#',
    go='//',
    groovy='//',
    gtkrc='#',
    haskell='--',
    html = {P='<!--', S='-->'},
    icon='#',
    idl='//',
    inform='!',
    ini='#',
    Io='#',
    java='//',
    javascript='//',
    json = {P='/*',S='*/'},
    jsp='//',
    latex='%',
    ledger='#',
    less='//',
    lilypond='%',
    lisp=';',
    logtalk='%',
    lua = {L='--', P='--[[', S=']]'},
    makefile='#',
    markdown = {P='<!--', S='-->'},
    matlab='#',
    moonscript='--',
    myrddin='//',
    nemerle='//',
    nsis='#',
    objective_c='//',
    pascal='//',
    perl='#',
    php='//',
    pico8='//',
    pike='//',
    pkgbuild='#',
    prolog='%',
    props='#',
    protobuf='//',
    ps='%',
    pure='//',
    python='#',
    rails='#',
    rc='#',
    rebol=';',
    rest='.. ', -- technically, ..\n, but that would break everything
    rexx='--',
    rhtml = {P='<!--', S='-->'},
    rstats='#',
    troff=[[.\"]],
    ruby='#',
    rust='//',
    sass='//',
    scala='//',
    scheme=';',
    smalltalk = {P='"', S='"'},
    sml='(*)',
    snobol4='#',
    sql='#',
    tcl='#',
    tex='%',
    toml='#',
    vala='//',
    vb="'",
    vbscript="'",
    verilog='//',
    vhdl='--',
    wsf={P='<!--', S='-->'},
    xml={P='<!--', S='-->'},
    yaml='#',
    zig='//',
    nim='#',
    julia='#',
    rpmspec='#',
    caml = { P='(*', S='*)' },
}
for k,v in pairs(comments_repl) do
    if type(v)=="string" then
        comments_repl[k] = {L=v} -- TODO: kinda wasteful doing this
    end
end
M.comments_repl = comments_repl

-- escape all magic characters with a '%'
local function esc(str)
    if not str then return "" end
    return (str:gsub('[[.+*?$^()%%%]-]', '%%%0'))
end

local Gsub = string.gsub

local function comment_line(lines, lnum, prefix, suffix)
    if suffix ~= "" then suffix = " " .. suffix end
    local indent, content = lines[lnum]:match("^(%s*)(.*)")
    lines[lnum] = indent .. prefix .. " " .. content .. suffix
end

local function uncomment_line(lines, lnum, prefix, suffix)
    if suffix~="" then suffix = esc(suffix) end
    local patt = "^(%s*)" .. esc(prefix) .. "%s?(.*)" .. suffix .. "$"
    lines[lnum] = Gsub(lines[lnum], patt, "%1%2")
end

local function is_comment(line, prefix)
    local s = line:find'%S'
    return s and (prefix == line:sub(s, s + #prefix - 1)) or false
end

local function toggle_line_comment(lines, lnum, prefix, suffix)
    local line = lines and lines[lnum]
    if not line then return end
    if line:find"^%s*$" then return end -- ignore empty lines
    -- is comment, so uncomment
    local iscomment = is_comment(line, prefix)
    local Toggle = iscomment and uncomment_line or comment_line
    Toggle(lines, lnum, prefix, suffix)
    return iscomment
end

-- if one line inside the block is not a comment, comment the block.
-- only uncomment, if every single line is comment.
local function block_comment(lines, line_start, line_end, prefix, suffix)
    local modify_line = uncomment_line
    for i=line_start,line_end do
        local line = lines[i]
        if line:find"%S" and not is_comment(line, prefix) then
            modify_line = comment_line
            break
        end
    end

    for i=line_start,line_end do
        if lines[i]:find"%S" then
            modify_line(lines, i, prefix, suffix)
        end
    end
    return modify_line == comment_line
end

-- TODO: modes should be in vis-std.lua
local modes = {}
for k,v in pairs( vis.modes ) do
    modes[k], modes[v] = v, k
end

-- I don't like this name, because it comment a section not a block
local function BlocksOperator(file, range, pos)
    local comment = comments_repl[vis.win.syntax]
    if not comment then return pos end
    local prefix, suffix = comment.P or comment.L, comment.S
    local cursor = range.start

    if modes[vis.mode]=="VISUAL_LINE" or suffix==nil then
        -- match range position to its line[] position
        -- block_comment only comments lines, not ranges.
        local iter = {file:lines_iterator()}
        local cpos, line_start = 0, 1
            for line in table.unpack(iter) do
                cpos = cpos + #line
                if cpos>range.start then break end
                cpos, line_start = cpos + 1, line_start + 1 -- newline added
            end
            local line_end = line_start
            for line in table.unpack(iter) do
                cpos = cpos + #line
                if cpos>range.finish then break end
                cpos, line_end = cpos + 1, line_end + 1
            end

        if comment.L then prefix, suffix = comment.L, '' end
        if block_comment(file.lines, line_start, line_end, prefix, suffix or '') then
            return cursor + #prefix
        end
    elseif suffix and prefix then
        if -- selection starts with a comment/prefix, uncomment
            file:content(range.start, #prefix)==prefix
            and -- must end with suffix
            file:content(range.finish-#suffix, #suffix)==suffix
        then -- uncomment
            file:delete(range.finish-#suffix, #suffix) -- erase suffix
            file:delete(range.start, #prefix) -- erase prefix
        else -- comment
            file:insert(range.finish, suffix) -- append
            file:insert(range.start, prefix) -- prepend
            return cursor + #prefix
        end
    else
        vis:message(
            string.format('ERROR: vis-commentary: syntax: %s, prefix: %s suffix: %s'
                , comment, prefix, suffix
        )   )
    end

    return cursor
end

local function CommentCurrentLine()
    local win = vis.win
    local lines = win.file.lines
    local comment = comments_repl[win.syntax]
    if not comment then return end
    local prefix, suffix = comment.L or comment.P, comment.S if comment.L then
        suffix = nil
    end

    for sel in win:selections_iterator() do
        local lnum = sel.line
        local column = sel.col
        local curpos = #prefix+1
        if toggle_line_comment(lines, lnum, prefix, suffix or '') then -- uncommented
            curpos = -curpos
        end
        curpos = column + curpos
        sel:to(lnum, curpos<0 and 0 or curpos) -- restore cursor position
    end

    win:draw()
end

function M.MapBlocks(
    key -- string|nil --
)
    key = key or 'gc'
    vis:operator_new(key, BlocksOperator, "Toggle comment on selected lines")
end

function M.MapLine(
    key -- string|nil --
)
    vis:map(
        vis.modes.NORMAL, key or "gcc", CommentCurrentLine
        , "Toggle comment on a the current line"
    )
end

-- Setup bindings to the default
function M.SetDefaults() M.MapBlocks() M.MapLine() end

return setmetatable(M, {__call = M.SetDefaults})