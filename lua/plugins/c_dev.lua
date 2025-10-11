return {
  -- LSP
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=never" },
        },
      },
    },
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "c", "cpp", "cmake", "make", "lua", "vim", "bash" },
      highlight = { enable = true },
      incremental_selection = { enable = true },
      indent = { enable = true },
    },
  },

  -- Formatting (Conform) -> clang-format
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        c = { "clang_format" },
        cpp = { "clang_format" },
      },
      format_on_save = { timeout_ms = 1000, lsp_fallback = true },
    },
  },

  -- DAP for C with codelldb
  {
    "mfussenegger/nvim-dap",
    dependencies = { "williamboman/mason.nvim", "jay-babu/mason-nvim-dap.nvim" },
    opts = {},
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = { "codelldb" },
      handlers = {},
    },
  },

  -- Mason ensure_installed
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "clangd", "codelldb", "clang-format" })
    end,
  },
}
