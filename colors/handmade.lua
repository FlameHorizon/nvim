vim.cmd("highlight clear")

if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
end

vim.g.colors_name = "handmade"

local hl = vim.api.nvim_set_hl

local c = {
    bg         = "#161616",
    fg         = "#CDAA7D",

    comment    = "#7F7F7F",

    green      = "#6B8E23",
    yellow     = "#CD950C",

    blue       = "#83A598",

    red        = "#FB4833",

    line       = "#6E6B5E",
    cursorline = "#DEDCD3",

    selection  = "#393634",
    visual     = "#83A598",
}

-- UI
hl(0, "Normal",       { fg = c.fg, bg = c.bg })
hl(0, "NormalFloat",  { fg = c.fg, bg = c.bg })
hl(0, "CursorLine",   { bg = c.selection })
hl(0, "CursorLineNr", { fg = c.cursorline, bold = true })
hl(0, "LineNr",       { fg = c.line })
hl(0, "Visual",       { bg = c.visual })
hl(0, "StatusLine",   { fg = c.fg, bg = c.bg })
hl(0, "VertSplit",    { fg = "#544F4F" })

-- Vim syntax
hl(0, "Comment",      { fg = c.comment })
hl(0, "Constant",     { fg = c.green })
hl(0, "String",       { fg = c.green })
hl(0, "Character",    { fg = c.green })
hl(0, "Number",       { fg = c.green })
hl(0, "Boolean",      { fg = c.green })
hl(0, "Float",        { fg = c.green })

hl(0, "Identifier",   { fg = c.fg })
hl(0, "Function",     { fg = c.yellow })

hl(0, "Statement",    { fg = c.fg })
hl(0, "Conditional",  { fg = c.fg })
hl(0, "Repeat",       { fg = c.fg })
hl(0, "Keyword",      { fg = c.fg })
hl(0, "Operator",     { fg = c.fg })

hl(0, "PreProc",      { fg = c.fg })

hl(0, "Type",         { fg = c.yellow })
hl(0, "StorageClass", { fg = c.yellow })
hl(0, "Structure",    { fg = c.yellow })
hl(0, "Typedef",      { fg = c.yellow })

hl(0, "Special",      { fg = c.yellow })
hl(0, "Tag",          { fg = c.yellow })
hl(0, "Delimiter",    { fg = c.fg })

hl(0, "Error",        { fg = c.red })
hl(0, "Todo",         { fg = c.blue, bold = true })

-- Treesitter
hl(0, "@comment",              { link = "Comment" })
hl(0, "@string",               { link = "String" })
hl(0, "@string.escape",        { link = "String" })
hl(0, "@number",               { link = "Number" })
hl(0, "@boolean",              { link = "Boolean" })
hl(0, "@constant",             { link = "Constant" })

hl(0, "@function",             { link = "Function" })
hl(0, "@function.builtin",     { fg = c.red })

hl(0, "@type",                 { link = "Type" })
hl(0, "@type.builtin",         { link = "Type" })
hl(0, "@constructor",          { fg = c.yellow })

hl(0, "@keyword",              { link = "Keyword" })
hl(0, "@operator",             { link = "Operator" })

hl(0, "@variable",             { fg = c.fg })
hl(0, "@property",             { fg = c.fg })

hl(0, "@tag",                  { fg = c.yellow })
hl(0, "@attribute",            { fg = c.yellow })

hl(0, "@markup.link",          { fg = "#8EC07C", italic = true })
hl(0, "@markup.heading",       { fg = "#B8BB25", bold = true })
