require("copilot").setup({
  suggestion = { enabled = false },
  panel = {
    enabled = false,
    layout = {
      position = "bottom",
      ratio = 0.3
    }
  }
})

require('avante').setup({
  provider = "deepseek",
  vendors = {
    deepseek = {
      __inherited_from = "openai",
      api_key_name = "DEEPSEEK_API_KEY",
      endpoint = "https://api.deepseek.com",
      model = "deepseek-coder",
    },
  }
})
