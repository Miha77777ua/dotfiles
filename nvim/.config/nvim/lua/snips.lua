local cmp = require('blink.cmp')
cmp.build():pwait()
cmp.setup({
  fuzzy = { implementation = "rust" },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
  keymap = { preset = "super-tab" },
})
