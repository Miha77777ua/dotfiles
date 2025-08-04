-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map("n", "<leader>lt", "<cmd>terminal live-server<cr>", { desc = "Open LiveServer" })
map(
  "n",
  "<leader>o",
  "<cmd>terminal sass scss/main.scss:css/main.min.css --style compressed<cr>",
  { desc = "Compile SCSS to CSS" }
)
map("n", "<leader>r", '<cmd>%s/class[^=]*="\\([^"]*\\)"/className={style.\\1}<cr>', { desc = "Regex for module files" })
