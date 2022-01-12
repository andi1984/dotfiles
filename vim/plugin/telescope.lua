 require("telescope").setup{
    defaults = {
      path_display = {
        "shorten",
        "absolute"
      },
    },
    pickers = {
      find_files = {
        hidden = true
      }
    }
}

vim.api.nvim_set_keymap(
  "n",
  "<space>fb",
  ":Telescope file_browser",
  { noremap = true }
)
