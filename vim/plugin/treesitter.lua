-- Neovim 0.11+ has built-in treesitter support.
-- Highlighting is enabled by default via vim.treesitter.
-- Use :TSInstall <lang> to install parsers as needed.

-- Add nvim-treesitter runtime dir to rtp so query files (highlights,
-- injections, etc.) are found for all languages including Vue.
-- Without this, queries at plugged/nvim-treesitter/runtime/queries/ are
-- invisible because only the plugin root is on the runtimepath.
local ts_runtime = vim.fs.joinpath(vim.fn.stdpath('config'), 'plugged', 'nvim-treesitter', 'runtime')
if vim.uv.fs_stat(ts_runtime) then
  vim.opt.rtp:prepend(ts_runtime)
end

-- Enable treesitter-based highlighting for all supported languages
vim.treesitter.start = vim.treesitter.start or function() end

-- Ensure highlight is enabled (Neovim 0.11+ default)
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})
