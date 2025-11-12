return {
	"folke/snacks.nvim",
	opts = {
		scroll = {
			enabled = false,
		},
		-- Disable Snacks replacements for vim.ui.select/input to avoid empty pickers
		select = { enabled = false },
		input = { enabled = false },
		-- Fully disable Snacks picker to avoid unexpected popups on open
		picker = { enabled = false },
	},
}
