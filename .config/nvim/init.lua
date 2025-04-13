package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua;"
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua;"

-- local group_cdpwd = vim.api.nvim_create_augroup("group_cdpwd", { clear = true })
-- vim.api.nvim_create_autocmd("VimEnter", {
--   group = group_cdpwd,
--   pattern = "*",
--   callback = function()
--     local path = vim.fn.expand("%:p:h"):gsub("oil://", "")
--     vim.api.nvim_set_current_dir(path)
--   end,
-- })

vim.filetype.add({
  extension = {
    gliffy = "json",
  },
})

require("config.lazy")
require("config.dev")
require("config.statusbar")
