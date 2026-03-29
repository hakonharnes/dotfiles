return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    words = { enabled = true },
    lazygit = {
      config = {
        os = {
          editPreset = "nvim-remote",
        },
      },
    },
    zen = {
      win = {
        backdrop = false,
      },
      zoom = {
        win = {
          backdrop = { transparent = false, blend = 0 },
        },
      },
    },
  },
}
