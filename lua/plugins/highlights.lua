return {
  {
    "folke/tokyonight.nvim",
    opts = {
      on_highlights = function(hl, c)
        -- Make line numbers brighter and the current line number stand out
        hl.LineNr = { fg = c.fg or "#b3b3b3" }
        hl.CursorLineNr = { fg = c.yellow or "#ffd75f", bold = true }
        -- Keep relative numbers consistent
        hl.LineNrAbove = { link = "LineNr" }
        hl.LineNrBelow = { link = "LineNr" }
      end,
    },
  },
}
