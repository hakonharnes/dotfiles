return {
  "HakonHarnes/img-clip.nvim",
  event = "VeryLazy",
  dir = "/Users/hakon/img-clip.nvim/",
  config = {
    template = {
      [{ "pdf", "dog" }] = "[$CURSOR]($FILE_PATH)",
      ["*"] = "![$CURSOR]($FILE_PATH)",
    },

    default = {
      drag_and_drop = {
        insert_mode = true,
      },
    },
    filetypes = {
      markdown = {
        dir_path = "dog",
      },
    },
  },
  keys = {
    { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste clipboard image" },
  },
}
