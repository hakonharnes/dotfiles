P = function(v)
  print(vim.inspect(v))
  return v
end

-- source files and call pasteImage()
-- vim.api.nvim_create_user_command("Test", function()
--   for moduleName, _ in pairs(package.loaded) do
--     if moduleName:match("^img%-clip") then
--       package.loaded[moduleName] = nil
--     end
--   end
--   require("img-clip").pasteImage()
-- end, {})

-- vim.api.nvim_set_keymap("n", "<leader>d", "<cmd>:so %<cr>", {})
