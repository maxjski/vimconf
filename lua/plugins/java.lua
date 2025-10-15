return {
  -- nvim-jdtls: Advanced Java LSP client
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    dependencies = {
      "mfussenegger/nvim-dap",
      "mason-org/mason.nvim",
    },
    config = function()
      -- This will be loaded when a Java file is opened
      -- The actual setup is done via autocmd (see below)
    end,
  },

  -- Treesitter for Java
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "java" })
    end,
  },

  -- Formatting (Conform) -> google-java-format
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        java = { "google-java-format" },
      },
    },
  },

  -- Mason ensure_installed for Java tools
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "jdtls", -- Java LSP
        "java-debug-adapter", -- DAP for Java
        "java-test", -- Test adapter
        "google-java-format", -- Formatter
      })
    end,
  },

  -- LSP Config (disable default Java LSP since we use jdtls)
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        jdtls = function()
          return true -- avoid duplicate servers
        end,
      },
    },
  },
}

