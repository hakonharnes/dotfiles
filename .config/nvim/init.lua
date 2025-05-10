package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua;"
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua;"

vim.filetype.add({
  extension = {
    gliffy = "json",
  },
})

require("config.lazy")
require("config.dev")
require("config.statusbar")
