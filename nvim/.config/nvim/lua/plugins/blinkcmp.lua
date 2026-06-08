return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      preset = "none",
      ["<Tab>"] = { "accept", "fallback" }, -- your changes here according to blink's docs
      ["<Up>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
    },
  },
}
