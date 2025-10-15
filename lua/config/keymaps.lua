-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Center view after Ctrl+d and Ctrl+u
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true, desc = "Half page down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true, desc = "Half page up and center" })

-- Ctrl+Backspace to delete previous word in insert mode
vim.keymap.set("i", "<C-H>", "<C-w>", { noremap = true, desc = "Delete previous word" })
vim.keymap.set("i", "<C-BS>", "<C-w>", { noremap = true, desc = "Delete previous word" })