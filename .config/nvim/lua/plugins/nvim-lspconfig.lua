return {
  "neovim/nvim-lspconfig",
  opts = {
    inlay_hints = { enabled = false },
    biome = false,
    servers = {
      lua_ls = {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      },
      vtsls = {
        settings = {
          typescript = {
            preferences = {
              importModuleSpecifier = "non-relative",
            },
          },
        },
      },
    },
  },
}
