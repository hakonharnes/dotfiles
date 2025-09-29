return {
  "stevearc/oil.nvim",
  config = function()
    require("oil").setup({
      cleanup_delay_ms = 0,

      view_options = {
        is_hidden_file = function(name, bufnr)
          return vim.startswith(name, ".")
            or vim.endswith(name, ".pdf")
            or name == "__pycache__"
            or name == "node_modules"
            or name == "venv"
            or name == "dist"
        end,
      },

      buf_options = {
        buflisted = true,
      },

      use_default_keymaps = false,
      lsp_file_methods = {
        autosave_changes = true,
      },

      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["~"] = "actions.tcd",
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
        ["g\\"] = "actions.toggle_trash",
        ["gh"] = '<cmd>lua require("oil").select({ horizontal = true, close = true })<cr>',
        ["gv"] = '<cmd>lua require("oil").select({ vertical = true, close = true })<cr>',
        ["g-"] = '<cmd>lua require("oil").select({ horizontal = true, close = true })<cr>',
        ["g|"] = '<cmd>lua require("oil").select({ vertical = true, close = true })<cr>',
        ["gt"] = '<cmd>lua require("oil").select({ tab = true, close = true })<cr>',
        ["gd"] = "actions.cd",
        ["<leader>p"] = function()
          local oil = require("oil")
          local filename = oil.get_cursor_entry().name
          local dir = oil.get_current_dir()
          oil.close()

          local img_clip = require("img-clip")
          img_clip.paste_image({}, dir .. filename)
        end,
      },

      keymaps_help = {
        border = "single",
      },

      preview = {
        border = "single",
      },

      progress = {
        border = "single",
      },

      float = {
        border = "single",
      },

      ssh = {
        border = "single",
      },
    })
  end,
  dependencies = { "nvim-tree/nvim-web-devicons" },
}
