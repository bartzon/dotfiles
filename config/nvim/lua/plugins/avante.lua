return {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    build = "make",
    opts = {
      provider = "openai",
      openai = {
        endpoint = os.getenv("OPENAI_API_CHAT_COMPLETIONS"),
        model = "anthropic:claude-3-5-sonnet",
        timeout = 30000, -- Timeout in milliseconds
        temperature = 0,
        max_tokens = 4096,
        ["local"] = false,
      },
    }
  }
