local Util = require("lazyvim.util")

local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then
      opts.remap = nil
    end
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

-- enter normal mode with jk
map("i", "jk", "<esc>", { desc = "Enter normal mode" })

-- copy/paste entire buffer
map("n", "<leader>Y", "<cmd>:%y+<cr>", { desc = "Copy entire buffer to clipboard" })
map("n", "<leader>P", ":silent! %delete _ | 0put +<CR>", { desc = "Replace entire buffer with clipboard content" })

-- bibtex
map("n", "<c-b>", "<cmd>Telescope bibtex<cr>", { desc = "Open bibtex entries" })
map("i", "<c-b>", "<cmd>Telescope bibtex<cr>", { desc = "Open bibtex entries" })

-- oil
map("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })
map("n", "_", "<cmd>lua require('oil.actions').open_cwd.callback()<CR>", { desc = "Open current directory" })

-- LazyVim
map("n", "<leader>l", "<nop>", { desc = "Lazy" })
map("n", "<leader>lz", "<cmd>:Lazy<cr>", { desc = "Lazy" })

-- last used file
map("n", "<tab>", "<cmd>b#<cr>", { desc = "Switch to last used file" })

-- tabs
-- map("n", "<tab>n", "<cmd>tabnew<cr>", { desc = "New tab" })
-- map("n", "<tab>d", "<cmd>tabclose<cr>", { desc = "Close tab" })
--
-- map("n", "<tab>0", "<cmd>set showtabline=0<cr>", { desc = "Set showtabline=0" })
-- map("n", "<tab>1", "<cmd>set showtabline=1<cr>", { desc = "Set showtabline=1" })
-- map("n", "<tab>2", "<cmd>set showtabline=2<cr>", { desc = "Set showtabline=2" })

map("n", "L", "<cmd>tabnext<cr>", { desc = "Next tab" })
map("n", "H", "<cmd>tabprev<cr>", { desc = "Prev tab" })
-- map("n", "<tab>", "<cmd>tabnext<cr>", { desc = "Next tab" })
-- map("n", "<s-tab>", "<cmd>tabprev<cr>", { desc = "Prev tab" })

map("n", "<m-1>", "<cmd>tabn1<cr>", { desc = "Tab 1" })
map("n", "<m-2>", "<cmd>tabn2<cr>", { desc = "Tab 2" })
map("n", "<m-3>", "<cmd>tabn3<cr>", { desc = "Tab 3" })
map("n", "<m-4>", "<cmd>tabn4<cr>", { desc = "Tab 4" })
map("n", "<m-5>", "<cmd>tabn5<cr>", { desc = "Tab 5" })
map("n", "<m-6>", "<cmd>tabn6<cr>", { desc = "Tab 6" })
map("n", "<m-7>", "<cmd>tabn7<cr>", { desc = "Tab 7" })
map("n", "<m-8>", "<cmd>tabn8<cr>", { desc = "Tab 8" })
map("n", "<m-9>", "<cmd>tabn9<cr>", { desc = "Tab 9" })
map("n", "<m-0>", "<cmd>tabn0<cr>", { desc = "Tab 10" })

-- LazyDocker
-- map("n", "<leader>ld", function()
--   Util.terminal({ "lazydocker" }, { cwd = Util.root(), esc_esc = false, ctrl_hjkl = false })
-- end, { desc = "Lazydocker (root dir)" })

-- run current file in terminal
-- map("n", "<leader><CR>", function()
--   Util.terminal({ "sh", "-c", "run " .. vim.fn.expand("%") }, {
--     cwd = Util.root(),
--     esc_esc = false,
--     ctrl_hjkl = false,
--     border = "single",
--     size = { width = 0.8, height = 0.8 },
--   })
-- end, { desc = "Run current file" })

map("n", "<CR>", function()
  Snacks.terminal({ "sh", "-c", "gliffy-run" }, {
    cwd = Util.root(),
    esc_esc = false,
    ctrl_hjkl = false,
    border = "single",
    size = { width = 0.8, height = 0.8 },
  })
end, { desc = "Run current file" })

-- run current file in tmux split
map("n", "<leader>D", function()
  os.execute("tmux split-window -h -d -l 30% bash -c 'run " .. vim.fn.expand("%") .. "'")
end, { desc = "Run current file in tmux split" })

-- noice keymaps
map("n", "<leader>nn", "<cmd>:NoiceLast<cr>", { desc = "Open noice" })
map("n", "<leader>nd", "<cmd>:NoiceDismiss<cr>", { desc = "Open noice" })
