return {
  dir = "~/itop.nvim",
  ft = { "php", "xml" },
  opts = {
    url = "http://localhost:8000",
  },
  keys = {
    -- Compilation
    { "<leader>ic", "<cmd>ITopCompile<cr>", desc = "iTop: Compile code" },
    { "<leader>iC", "<cmd>ITopCompileDatabase<cr>", desc = "iTop: Compile code + database" },

    -- Validation
    { "<leader>im", "<cmd>ITopCheckModel<cr>", desc = "iTop: Check model" },
    { "<leader>id", "<cmd>ITopCheckDatabase<cr>", desc = "iTop: Check database schema" },

    -- Data integrity
    { "<leader>ih", "<cmd>ITopCheckHierarchicalKeys<cr>", desc = "iTop: Check hierarchical keys" },
    { "<leader>iH", "<cmd>ITopBuildHierarchicalKeys<cr>", desc = "iTop: Rebuild hierarchical keys" },
    { "<leader>is", "<cmd>ITopCheckDataSources<cr>", desc = "iTop: Check data sources" },
    { "<leader>iS", "<cmd>ITopFixDataSources<cr>", desc = "iTop: Fix data sources" },

    -- Translations
    { "<leader>it", "<cmd>ITopCheckDictionary<cr>", desc = "iTop: Check dictionary" },
  },
}
