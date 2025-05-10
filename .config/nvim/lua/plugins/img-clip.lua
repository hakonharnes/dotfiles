return {
  "HakonHarnes/img-clip.nvim",
  event = "VeryLazy",
  opts = {
    filetypes = {
      markdown = {
        relative_to_current_file = true,
      },
    },
  },

  keys = {
    { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste clipboard image" },
  },
}
