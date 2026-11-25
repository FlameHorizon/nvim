return {
  {
    "shaunsingh/nord.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- Disable bold and italic formatting
      vim.g.nord_bold = false
      vim.g.nord_italic = false
      vim.g.nord_italic_comments = false

      -- Define your darker background color
      local dark_bg = "#0f191f"

      -- Override background highlight groups when loading Nord
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "nord",
        callback = function()
          local groups = {
            "Normal",
            "NormalFloat",
            "NormalNC",
            "SignColumn",
            "LineNr",
            "CursorLineNr",
            "FoldColumn",
            "MsgArea",
            "@none",
            "@text",
            "@text.literal",
            "@markup",
            "@markup.raw",
	    "qfLineNr",
          }
          for _, group in ipairs(groups) do
            vim.api.nvim_set_hl(0, group, { fg = muted_fg, bg = dark_bg })
          end

      	  local highlight_line = "#202433"
          local muted_fg = "#A8B0C0" 
	  vim.api.nvim_set_hl(0, "CursorLine", { bg = highlight_line })

          -- Override Normal explicitly with BOTH fg and bg
          vim.api.nvim_set_hl(0, "Normal", { fg = muted_fg, bg = dark_bg })

          local text_groups = {
            -- Variables & Identifiers
            "Identifier",
            "@variable",
            "@variable.builtin",
            "@variable.parameter",
            "@variable.member",
            "@property",
            "@field",

            -- Types & Classes
            "Type",
            "@type",
            "@type.builtin",
            "@type.definition",

            -- Keywords & Statements
            "Statement",
            "Keyword",
            "@keyword",
            "@keyword.function",
            "@keyword.operator",
            "@keyword.return",
            "@keyword.conditional",
            "@repeat",
	    "Conditional",

            -- Operators & Delimiters
            "Operator",
            "Delimiter",
            "@operator",
            "@punctuation.delimiter",
            "@punctuation.bracket",
            "@punctuation.special",

            -- Strings, Numbers, & Constants
            "Constant",
            "String",
            "Character",
            "Number",
            "Boolean",
            "Float",
            "@constant",
            "@constant.builtin",
            "@string",
            "@number",
            "@boolean",

            -- Modules & Imports
            "PreProc",
            "@module",
            "@namespace",
	    "Include",
          }

          for _, group in ipairs(text_groups) do
            vim.api.nvim_set_hl(0, group, { fg = muted_fg })
          end
        end,
      })

      vim.cmd.colorscheme("nord")
    end,
  },
}
