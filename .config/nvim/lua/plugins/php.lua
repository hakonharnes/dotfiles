local function find_project_root(filename)
  if type(filename) == "number" then
    filename = vim.api.nvim_buf_get_name(filename)
  end

  if not filename or filename == "" then
    return nil
  end

  local markers = { ".git", "phpcs.xml.dist", ".php-cs-fixer.dist.php" }

  local found_markers = vim.fs.find(markers, { path = filename, upward = true })

  if found_markers and #found_markers > 0 then
    local root = vim.fs.dirname(found_markers[1])
    return root
  end

  return nil
end

return {
  -- Tressitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "php" })
      end
    end,
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        phpactor = {
          enabled = false,
        },
        intelephense = {
          enabled = true,
          root_dir = function(fname)
            return find_project_root(fname)
          end,
          settings = {
            intelephense = {
              format = {
                enable = false,
              },
            },
          },
        },
      },
    },
  },

  -- Mason
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "phpcs",
        "phpcbf",
        "php-cs-fixer",
      })
    end,
  },

  -- Linting
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        php = { "phpcs" },
      },
      linters = {
        phpcs = {
          condition = function(ctx)
            local filename = ctx.filename
            if string.find(filename, "itop") then
              return string.find(filename, "extensions/") or string.find(filename, "pages/")
            end
            return true
          end,
        },
      },
    },
  },

  -- Formatting
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        php = { "phpcbf", "php_cs_fixer" },
      },
      formatters = {
        phpcbf = {
          condition = function(_, ctx)
            local filename = ctx.filename
            if string.find(filename, "itop") then
              return string.find(filename, "extensions/") or string.find(filename, "pages/")
            end
            return true
          end,
        },
        php_cs_fixer = {
          prepend_args = function(_, ctx)
            local root = find_project_root(ctx.filename)

            if root then
              return { "--config=" .. root .. "/.php-cs-fixer.dist.php" }
            end
            return {}
          end,
        },
      },
    },
  },
}
