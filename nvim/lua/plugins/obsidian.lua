return {
  "epwalsh/obsidian.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
  },
  version = "*",  -- use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "~/Documents/Vault",
      },
    },
    completion = {
      nvim_cmp = true,
      min_chars = 1,
    },
  }
}
