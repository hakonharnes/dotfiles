return {
  -- "HakonHarnes/img-clip.nvim",
  dir = "/Users/hakon/img-clip.nvim/",
  event = "VeryLazy",
  config = {
    default = {
      verbose = false,
    },
    filetypes = {
      markdown = {
        copy_images = true,
      },
    },
  },
  keys = {
    { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste clipboard image" },
  },
}
