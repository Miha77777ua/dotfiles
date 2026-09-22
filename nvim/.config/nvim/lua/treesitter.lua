require('nvim-treesitter').install { "python", "bash", "html", "css", "markdown" }

vim.api.nvim_create_autocmd('FileType', {
  pattern = { "python", "sh", "html", "css", "markdown" },
  callback = function() vim.treesitter.start() end,
})
