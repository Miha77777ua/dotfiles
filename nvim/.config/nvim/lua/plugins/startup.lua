return {
  {
    "folke/snacks.nvim",

    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      picker = {
        hidden = true,
        ignored = true,
        sources = {
          files = { ignored = true, hidden = true },
          explorer = { ignored = true, hidden = true },
          grep = { ignored = true, hidden = true },
          grep_word = { ignored = true, hidden = true },
          grep_buffers = { ignored = true, hidden = true },
        }
      },
      dashboard = {
        enabled = true,
        preset = {
          header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
]],
        },
      }
    }
  }
}
