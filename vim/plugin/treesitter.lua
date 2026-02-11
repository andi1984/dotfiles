-- Neovim 0.11+ has built-in treesitter support.
-- Highlighting is enabled by default via vim.treesitter.
-- Use :TSInstall <lang> to install parsers as needed.

-- Enable treesitter-based highlighting for all supported languages
vim.treesitter.start = vim.treesitter.start or function() end

-- Ensure highlight is enabled (Neovim 0.11+ default)
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})
