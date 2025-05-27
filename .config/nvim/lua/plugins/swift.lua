return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        sourcekit = {
          capabilities = {
            workspace = {
              didChangeWatchedFiles = {
                dynamicRegistration = true,
              },
            },
          },
        },
      },
      diagnostics = {
        virtual_text = true,
      },
      setup = {
        sourcekit = function(_, opts) end,
      },
    },

    keys = {
      { "K", vim.lsp.buf.hover, desc = "Hover" },
      { "gd", vim.lsp.buf.definition, desc = "Goto Definition" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "swift" })
      end
    end,
  },
}
