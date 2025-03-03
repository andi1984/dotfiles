require('avante').setup {
        ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
  provider = "copilot", -- The provider used in Aider mode or in the planning phase of Cursor Planning Mode
}
