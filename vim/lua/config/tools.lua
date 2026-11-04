-- External tools this config expects. vim/install.sh installs them; missing
-- ones are also installed in the background on startup.
return {
  -- nvim-treesitter (main) parsers
  parsers = {
    "typescript", "javascript", "tsx", "vue", "html", "css", "scss",
    "lua", "vim", "vimdoc", "query",
    "go", "rust", "python", "java", "kotlin",
    "json", "yaml", "toml", "markdown", "markdown_inline",
    "bash", "graphql", "dockerfile", "astro", "twig", "styled",
    "regex", "jsdoc", "diff", "gitcommit",
  },
}
