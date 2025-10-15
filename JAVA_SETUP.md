# Java Development Setup for Neovim

## Overview
Your Neovim is now configured for professional Java development with:
- **Language Server Protocol (LSP)** via nvim-jdtls
- **Debugging (DAP)** with Java Debug Adapter
- **Testing** with Java Test Runner
- **Code Formatting** with google-java-format
- **Syntax Highlighting** via Treesitter

## Installed Tools

The following tools will be automatically installed via Mason when you first open a Java file:
- `jdtls` - Eclipse JDT Language Server
- `java-debug-adapter` - Debugger
- `java-test` - Test runner
- `google-java-format` - Code formatter

## Java-Specific Keybindings

All keybindings use the `<leader>` key (default is Space in LazyVim).

### Code Actions
- `<leader>co` - **Organize Imports** - Remove unused and sort imports
- `<leader>cv` - **Extract Variable** - Extract expression to variable (works in visual mode)
- `<leader>cc` - **Extract Constant** - Extract expression to constant (works in visual mode)
- `<leader>cm` - **Extract Method** - Extract selected code to method (visual mode)

### Testing
- `<leader>ct` - **Test Class** - Run all tests in current class
- `<leader>cm` - **Test Method** - Run test at cursor

### Standard LSP Keybindings (from LazyVim)
- `gd` - Go to definition
- `gr` - Go to references
- `gI` - Go to implementation
- `gy` - Go to type definition
- `K` - Show hover documentation
- `<leader>ca` - Code actions
- `<leader>cr` - Rename symbol
- `<leader>cf` - Format code

### Debugging (DAP)
LazyVim provides these DAP keybindings:
- `<leader>db` - Toggle breakpoint
- `<leader>dB` - Breakpoint condition
- `<leader>dc` - Continue
- `<leader>dC` - Run to cursor
- `<leader>dg` - Go to line (no execute)
- `<leader>di` - Step into
- `<leader>dj` - Down
- `<leader>dk` - Up
- `<leader>dl` - Run last
- `<leader>do` - Step out
- `<leader>dO` - Step over
- `<leader>dp` - Pause
- `<leader>dr` - Toggle REPL
- `<leader>ds` - Session
- `<leader>dt` - Terminate
- `<leader>dw` - Widgets

## Project Structure Support

The LSP will automatically detect your project type based on these files:
- `pom.xml` - Maven projects
- `build.gradle` / `gradlew` - Gradle projects
- `.git` - Git repository root

## Features

### Automatic Features
- **Code Completion** - IntelliSense-style completion
- **Error Checking** - Real-time diagnostics
- **Import Management** - Auto-import suggestions
- **Code Lens** - Shows implementations and references inline
- **Signature Help** - Parameter hints while typing
- **Hot Code Replace** - Update running code during debug sessions

### Project Features
- Maven and Gradle integration
- JUnit test support
- Source code download for dependencies
- Decompiled source viewing
- Workspace management (separate workspaces per project)

## Getting Started

1. **Open a Java file or project** - The LSP will start automatically
2. **Wait for initialization** - First time may take a moment as jdtls analyzes the project
3. **Check status** - Use `:LspInfo` to verify jdtls is running
4. **Start coding!**

## Workspace Storage

JDTLS stores workspace data in: `~/.local/share/nvim/jdtls-workspace/<project-name>/`

Each project gets its own workspace to avoid conflicts.

## Troubleshooting

### LSP Not Starting
1. Open a Java file in a project with `pom.xml` or `build.gradle`
2. Check `:LspInfo` to see if jdtls is attached
3. Check `:Mason` to verify jdtls is installed

### Debugging Not Working
1. Ensure you have a `main` method or JUnit test
2. Use `<leader>dc` to continue/start debugging
3. Check `:DapShowLog` for debug adapter logs

### Formatting Issues
1. Format manually with `<leader>cf`
2. Check if google-java-format is installed: `:Mason`

## Configuration Files

- `/home/frieren/.config/nvim/lua/plugins/java.lua` - Plugin declarations
- `/home/frieren/.config/nvim/lua/config/autocmds.lua` - JDTLS setup and configuration

## Java Version

Currently using the system Java installed via pacman:
```bash
java -version  # Check your Java version
```

To use a different Java version, modify the `cmd` array in `autocmds.lua` to point to a specific Java installation.

