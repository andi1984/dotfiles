-- Completion
return {
  {
    "saghen/blink.cmp",
    version = "1.*", -- release tags ship the prebuilt fuzzy matcher
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = { "Kaiser-Yang/blink-cmp-git" },
    opts = {
      keymap = {
        -- <CR> accepts, <C-Space> opens, <C-e> closes, <C-b>/<C-f> scroll docs
        preset = "enter",
        -- leave <Tab>/<S-Tab> to tabout.nvim and native snippet jumps
        ["<Tab>"] = false,
        ["<S-Tab>"] = false,
      },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 300 },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        per_filetype = { gitcommit = { "git", "buffer" } },
        providers = {
          git = { module = "blink-cmp-git", name = "Git" },
        },
      },
      cmdline = {
        completion = { menu = { auto_show = true } },
      },
      signature = { enabled = true },
    },
  },
}
