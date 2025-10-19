-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Ensure line numbers are clearly visible across themes by overriding highlights
local function set_line_number_highlights()
  -- Adjust these colors to taste
  vim.api.nvim_set_hl(0, "LineNr", { fg = "#aeb2d1" })
  vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ffd75f", bold = true })
end

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("UserLineNumberHighlights", { clear = true }),
  callback = set_line_number_highlights,
})
--
-- Apply once on startup (before any ColorScheme change)
set_line_number_highlights()

-- Java LSP setup with nvim-jdtls
vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    local jdtls = require("jdtls")

    -- Find root directory for workspace
    local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
    local root_dir = require("jdtls.setup").find_root(root_markers)
    if not root_dir then
      return
    end

    -- Data directory for jdtls workspace storage
    local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

    -- Get Mason installation paths (Mason installs to stdpath("data")/mason)
    local mason_path = vim.fn.stdpath("data") .. "/mason/packages"
    local jdtls_install = mason_path .. "/jdtls"
    local java_debug_install = mason_path .. "/java-debug-adapter"
    local java_test_install = mason_path .. "/java-test"
    
    -- Check if jdtls is actually installed
    if vim.fn.isdirectory(jdtls_install) == 0 then
      vim.notify("jdtls not found. Please install it via :Mason", vim.log.levels.WARN)
      return
    end

    -- Bundles for debugging and testing
    local bundles = {
      vim.fn.glob(java_debug_install .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", true),
    }
    vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_install .. "/extension/server/*.jar", true), "\n"))

    -- Determine OS-specific config
    local os_config = "linux"
    if vim.fn.has("mac") == 1 then
      os_config = "mac"
    elseif vim.fn.has("win32") == 1 then
      os_config = "win"
    end

    -- JDTLS configuration
    local config = {
      cmd = {
        "java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xmx1g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",
        "-jar",
        vim.fn.glob(jdtls_install .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
        "-configuration",
        jdtls_install .. "/config_" .. os_config,
        "-data",
        workspace_dir,
      },
      root_dir = root_dir,
      settings = {
        java = {
          eclipse = {
            downloadSources = true,
          },
          configuration = {
            updateBuildConfiguration = "interactive",
          },
          maven = {
            downloadSources = true,
          },
          implementationsCodeLens = {
            enabled = true,
          },
          referencesCodeLens = {
            enabled = true,
          },
          references = {
            includeDecompiledSources = true,
          },
          format = {
            enabled = true,
          },
        },
        signatureHelp = { enabled = true },
        completion = {
          favoriteStaticMembers = {
            "org.hamcrest.MatcherAssert.assertThat",
            "org.hamcrest.Matchers.*",
            "org.hamcrest.CoreMatchers.*",
            "org.junit.jupiter.api.Assertions.*",
            "java.util.Objects.requireNonNull",
            "java.util.Objects.requireNonNullElse",
            "org.mockito.Mockito.*",
          },
        },
        contentProvider = { preferred = "fernflower" },
        extendedClientCapabilities = jdtls.extendedClientCapabilities,
        sources = {
          organizeImports = {
            starThreshold = 9999,
            staticStarThreshold = 9999,
          },
        },
        codeGeneration = {
          toString = {
            template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
          },
          useBlocks = true,
        },
      },
      flags = {
        allow_incremental_sync = true,
      },
      init_options = {
        bundles = bundles,
      },
    }

    -- Setup key mappings and autocommands for LSP
    config.on_attach = function(client, bufnr)
      -- Regular LSP mappings (provided by LazyVim)
      -- Additional Java-specific mappings
      local opts = { buffer = bufnr, silent = true }

      -- Code actions
      vim.keymap.set("n", "<leader>co", function()
        require("jdtls").organize_imports()
      end, vim.tbl_extend("force", opts, { desc = "Organize Imports" }))

      vim.keymap.set("n", "<leader>ct", function()
        require("jdtls").test_class()
      end, vim.tbl_extend("force", opts, { desc = "Test Class" }))

      vim.keymap.set("n", "<leader>cm", function()
        require("jdtls").test_nearest_method()
      end, vim.tbl_extend("force", opts, { desc = "Test Method" }))

      vim.keymap.set("n", "<leader>cv", function()
        require("jdtls").extract_variable()
      end, vim.tbl_extend("force", opts, { desc = "Extract Variable" }))

      vim.keymap.set("v", "<leader>cv", function()
        require("jdtls").extract_variable(true)
      end, vim.tbl_extend("force", opts, { desc = "Extract Variable" }))

      vim.keymap.set("n", "<leader>cc", function()
        require("jdtls").extract_constant()
      end, vim.tbl_extend("force", opts, { desc = "Extract Constant" }))

      vim.keymap.set("v", "<leader>cc", function()
        require("jdtls").extract_constant(true)
      end, vim.tbl_extend("force", opts, { desc = "Extract Constant" }))

      vim.keymap.set("v", "<leader>cm", function()
        require("jdtls").extract_method(true)
      end, vim.tbl_extend("force", opts, { desc = "Extract Method" }))

      -- DAP setup
      require("jdtls").setup_dap({ hotcodereplace = "auto" })
      require("jdtls.dap").setup_dap_main_class_configs()
    end

    -- Set capabilities (compatible with blink.cmp used in LazyVim)
    config.capabilities = vim.lsp.protocol.make_client_capabilities()
    
    -- Try to enhance with blink.cmp if available
    local ok_blink, blink = pcall(require, "blink.cmp")
    if ok_blink and blink.get_lsp_capabilities then
      config.capabilities = vim.tbl_deep_extend("force", config.capabilities, blink.get_lsp_capabilities())
    end

    -- Start jdtls
    jdtls.start_or_attach(config)
  end,
})
