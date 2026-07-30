local cmp = require('blink.cmp')
cmp.build():pwait()
cmp.setup({
  fuzzy = { implementation = "lua" },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
  keymap = { preset = "super-tab" },
})
