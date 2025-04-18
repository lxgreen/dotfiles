local c_blend = require("util").color_blend

local colors_get = function(flavor)
	return require("catppuccin.palettes").get_palette(flavor)
end

local override_all = function(c)
	return {
		AvanteTitle = { fg = c.lavender, bg = c.none, style = { "bold" } },
		AvanteReversedTitle = { fg = c.base, bg = c.lavender, style = { "bold" } },
		AvanteSubtitle = { fg = c.mauve, bg = c.none, style = { "italic" } },
		AvanteReversedSubtitle = { fg = c.base, bg = c.mauve, style = { "italic" } },
		AvanteThirdTitle = { fg = c.green, bg = c.none, style = { "bold" } },
		AvanteReversedThirdTitle = { fg = c.base, bg = c.green, style = { "bold" } },
		AvanteConflictCurrent = { bg = c_blend(c.blue, c.base, 90) },
		AvanteConflictCurrentLabel = { bg = c_blend(c.blue, c.base, 85), fg = c.text },
		AvanteConflictIncoming = { bg = c_blend(c.green, c.base, 90) },
		AvanteConflictIncomingLabel = { bg = c_blend(c.green, c.base, 85), fg = c.text },
		AvantePopupHint = { fg = c.overlay1 },
		AvanteInlineHint = { fg = c.overlay1, style = { "italic" } },
		AvantePromptInput = { fg = c.text, bg = c.base },
		AvantePromptInputBorder = { fg = c_blend(c.base, c.lavender, 50) },
		AerialLine = { fg = "none", bg = c.crust },
		AlphaFooter = { fg = c.surface1, style = {} },
		AlphaShortcut = { bg = c_blend(c.base, c.crust, 50), fg = c_blend(c.base, c.surface1, 50) },
		AlphaShortcutBorder = { fg = c_blend(c.base, c.surface1, 50) },
		ChatGPTQuestion = { fg = c.mauve },
		ChatGPTTotalTokens = { bg = "none", fg = c.overlay2 },
		ChatGPTTotalTokensBorder = { fg = c.text },
		CmpDocFloat = { bg = c.mantle, blend = 15 },
		DiffviewDiffAdd = { bg = c_blend(c.green, c.base, 93) },
		DiffviewDiffDelete = { bg = c_blend(c.red, c.base, 93) },
		DiffviewNormal = { bg = c.mantle },
		DiffviewWinSeparator = { link = "NeoTreeWinSeparator" },
		EdgyNormal = { link = "NormalFloat" },
		EdgyTitle = { bg = c.mantle, fg = c.mantle },
		FlashPrompt = { bg = c.mantle },
		Folded = { bg = c_blend(c.base, c.crust, 20), fg = c.surface0 },
		GlanceBorderTop = { bg = c.base, fg = c_blend(c.base, c.lavender, 30) },
		GlanceFoldIcon = { link = "FoldColumn" },
		GlanceListBorderBottom = { link = "GlanceBorderTop" },
		GlanceListNormal = { bg = c_blend(c.base, c.crust, 15), fg = c.subtext0 },
		GlancePreviewBorderBottom = { link = "GlanceBorderTop" },
		GlancePreviewNormal = { bg = c_blend(c.base, c.crust, 30) },
		GlanceWinBarFilename = { link = "GlanceWinBarTitle" },
		GlanceWinBarFilepath = { link = "GlanceWinBarTitle" },
		GlanceWinBarTitle = { fg = c.overlay0, bg = c_blend(c.base, c.crust, 50), style = { "bold" } },
		GitConflictCurrent = { bg = c_blend(c.blue, c.base, 90) },
		GitConflictCurrentLabel = { bg = c_blend(c.blue, c.base, 85) },
		GitConflictIncoming = { bg = c_blend(c.green, c.base, 90) },
		GitConflictIncomingLabel = { bg = c_blend(c.green, c.base, 85) },
		GitSignsAdd = { fg = c_blend(c.green, c.base, 50) },
		GitSignsAddInline = { bg = c_blend(c.green, c.base, 83) },
		GitSignsAddPreview = { bg = c_blend(c.green, c.base, 93) },
		GitSignsChange = { fg = c_blend(c.yellow, c.base, 50) },
		GitSignsDelete = { fg = c_blend(c.red, c.base, 50) },
		GitSignsDeleteInline = { bg = c_blend(c.red, c.base, 83) },
		GitSignsDeletePreview = { bg = c_blend(c.red, c.base, 93) },
		IblIndent = { fg = c_blend(c.base, c.text, 5) },
		IblScope = { fg = c_blend(c.base, c.text, 15) },
		LazyReasonKeys = { fg = c.overlay0 },
		NeoTreeCursorLine = { bg = c.crust },
		NeoTreeDotfile = { fg = c.overlay0 },
		NeoTreeFadeText1 = { fg = c.surface1 },
		NeoTreeFadeText2 = { fg = c.surface2 },
		NeoTreeFileStats = { fg = c.surface1 },
		NeoTreeFileStatsHeader = { fg = c.surface2 },
		NeoTreeFloatBorder = { link = "FloatBorder" },
		NeoTreeFloatNormal = { link = "NormalFloat" },
		NeoTreeFloatTitle = { link = "FloatTitle" },
		NeoTreeMessage = { fg = c.surface1 },
		NeoTreeModified = { fg = c.peach },
		NeoTreeRootName = { fg = c.green },
		NeoTreeTabActive = { fg = c.text, bg = c_blend(c.base, c.text, 10) },
		NeoTreeTabSeparatorActive = { bg = c.base, fg = c.base },
		NeoTreeWinSeparator = { bg = c.base, fg = c.base },
		NoiceCmdline = { bg = c.mantle },
		NoiceCmdlinePopupBorder = { link = "FloatBorder" },
		LspInlayHint = { bg = "none" },
		NoiceScrollbar = { link = "NormalFloat" },
		NoiceScrollbarThumb = { bg = c_blend(c.base, c.surface0, 50) },
		NoicePopupmenuSelected = { link = "Visual" },
		NoiceFormatEvent = { fg = c.overlay1 },
		NoiceFormatKind = { fg = c.overlay0 },
		NoiceLspProgressTitle = { fg = c.overlay0 },
		NoicePopup = { link = "NormalFloat" },
		NormalFloat = { bg = c.base },
		NotifyBackground = { bg = c.base },
		NotifyERRORBorder = { fg = c_blend(c.base, c.red, 30) },
		NotifyWARNBorder = { fg = c_blend(c.base, c.yellow, 30) },
		NotifyINFOBorder = { fg = c_blend(c.base, c.blue, 30) },
		NotifyDEBUGBorder = { fg = c_blend(c.base, c.peach, 30) },
		NotifyTRACEBorder = { fg = c_blend(c.base, c.rosewater, 30) },
		Pmenu = { bg = c_blend(c.crust, c.base, 50), blend = 15 },
		PmenuSbar = { bg = c_blend(c.crust, c.surface2, 30) },
		PmenuSel = { bg = c_blend(c.crust, c.surface2, 50) },
		PmenuThumb = { bg = c_blend(c.crust, c.surface2, 40) },
		TreesitterContext = { bg = c.base, blend = 10 },
		TreesitterContextBottom = { fg = c_blend(c.base, c.text, 15), blend = 0 },
		TreesitterContextLineNumber = { bg = c.base },
		TroubleCount = { bg = "none" },
		TroubleNormal = { link = "NormalFloat" },
		Visual = { link = "LspReferenceRead" },
		VisualWhitespace = { link = "LspReferenceRead" },
		WhichKeyFloat = { bg = c.mantle },
		Whitespace = { fg = c.base },
		WinSeparator = { fg = c_blend(c.base, c.crust, 40) },
		ZenBg = { bg = c.mantle },
	}
end

local override_dark = function(c)
	return {
		AlphaHeader1 = { fg = c.surface2 },
		AlphaHeader2 = { fg = c_blend(c.base, c.blue, 5) },
		AlphaHeader3 = { fg = c_blend(c.base, c.sky, 5) },
		AlphaHeader4 = { fg = c_blend(c.base, c.green, 5) },
		AlphaHeader5 = { fg = c_blend(c.base, c.yellow, 5) },
		AlphaHeader6 = { fg = c_blend(c.base, c.peach, 5) },
		AlphaHeader7 = { fg = c_blend(c.base, c.red, 5) },
		AlphaHeader8 = { fg = c.surface2 },
		AerialGuide = { fg = c.surface0 },
		FloatBorder = { fg = c_blend(c.base, c.lavender, 50) },
		FloatTitle = { fg = c.lavender, style = { "bold" } },
		GitSignsCurrentLineBlame = { fg = c.surface2 },
		IlluminatedWordRead = { bg = c_blend(c.base, c.surface2, 25) },
		IlluminatedWordText = { bg = c_blend(c.base, c.sapphire, 25) },
		IlluminatedWordWrite = { bg = c_blend(c.base, c.sapphire, 25) },
		NeoTreeIndentMarker = { fg = c.base },
		SatelliteBar = { bg = c.surface0, blend = 15 },
		SpectreBorderCustom = { fg = c.surface0 },
		SymbolUsageText = { fg = c.surface2 },
		-- Visual = { bg = c_blend(c.base, c.surface2, 30) },
		-- VisualWhitespace = { bg = c_blend(c.base, c.surface2, 30), fg = c.surface2 },
	}
end

local override_light = function(c)
	return {
		AlphaHeader1 = { fg = c.surface2 },
		AlphaHeader2 = { fg = c.blue },
		AlphaHeader3 = { fg = c.sky },
		AlphaHeader4 = { fg = c.green },
		AlphaHeader5 = { fg = c.yellow },
		AlphaHeader6 = { fg = c.peach },
		AlphaHeader7 = { fg = c.red },
		AlphaHeader8 = { fg = c.surface2 },
		AerialGuide = { fg = c.crust },
		FloatBorder = { fg = c_blend(c.base, c.text, 20) },
		FloatTitle = { fg = c.lavender, style = { "bold" } },
		GitSignsCurrentLineBlame = { fg = c.surface0 },
		IlluminatedWordRead = { bg = c_blend(c.base, c.surface2, 20) },
		IlluminatedWordText = { bg = c_blend(c.base, c.sapphire, 10) },
		IlluminatedWordWrite = { bg = c_blend(c.base, c.sapphire, 10) },
		NeoTreeIndentMarker = { fg = c.surface0 },
		SatelliteBar = { bg = c.crust, blend = 15 },
		SpectreBorderCustom = { fg = c.crust },
		SymbolUsageText = { fg = c.surface0 },
		-- Visual = { bg = c_blend(c.base, c.crust, 85) },
		-- VisualWhitespace = { bg = c_blend(c.base, c.crust, 85), fg = c.surface2 },
	}
end

local override_bufferline_hls = function(c)
	local hls = {
		fill = { bg = c.mantle },
		modified = { bg = c.mantle },
		pick = { bg = c.mantle },
		trunc_marker = { bg = c.mantle },

		buffer_visible = { fg = c.subtext0 },
		modified_visible = { fg = c.peach },
		duplicate_visible = { bg = c.base },
		separator = { fg = c.menlo },
		tab_selected = { fg = c.text, style = { "bold" } },
		tab_separator = { fg = c.mantle, bg = c.mantle },
		tab_separator_selected = { fg = c.base, bg = c.base },
	}

	-- stylua: ignore start
	local items = {
		"buffer", "close_button", "diagnostic", "error", "error_diagnostic",
		"hint", "indicator", "info", "info_diagnostic", "modified",
		"numbers", "pick", "warning", "warning_diagnostic",
	}
	-- stylua: ignore end

	for _, item in ipairs(items) do
		local key_selected = item .. "_selected"
		local key_visible = item .. "_visible"

		if hls[key_selected] == nil then
			hls[key_selected] = {}
		end

		if hls[key_visible] == nil then
			hls[key_visible] = {}
		end

		hls[key_selected].bg = c.base
		hls[key_visible].bg = c.base
	end

	return hls
end

local lualine_theme_create = function(c)
	local colors = {
		["normal"] = c.blue,
		["insert"] = c.green,
		["visual"] = c.mauve,
		["replace"] = c.red,
		["command"] = c.peach,
		["terminal"] = c.green,
		["inactive"] = c.mantle,
	}

	local theme = {}

	for mode, color in pairs(colors) do
		theme[mode] = {
			a = { bg = c_blend(c.mantle, color, 70), fg = c.mantle },
			b = { bg = c_blend(c.mantle, color, 15), fg = color },
			c = { bg = c_blend(c.base, c.mantle, 50), fg = mode == "inactive" and c.surface2 or c.text },
			x = { bg = c_blend(c.base, c.mantle, 50), fg = c.surface2 },
		}
	end

	return theme
end

local alpha_header_animate = function()
	local c = colors_get()
	local colors = { c.blue, c.sky, c.green, c.yellow, c.peach, c.red }
	local limit = require("util").os_theme_is_dark() and 100 or 20

	for i = 5, limit do
		vim.schedule(function()
			local timer = vim.loop.new_timer()

			if timer ~= nil then
				timer:start(
					i * 30,
					0,
					vim.schedule_wrap(function()
						for j = 2, 7 do
							vim.api.nvim_set_hl(0, "AlphaHeader" .. j, { fg = c_blend(c.base, colors[j - 1], i) })
						end
					end)
				)
			end
		end)
	end
end

return {
	{
		"catppuccin/nvim",
		name = "catppuccin",

		opts = {
			integrations = {
				navic = false,
				treesitter_context = true,
				dap = { enabled = true, enable_ui = true },
			},

			highlight_overrides = {
				all = override_all,
				frappe = override_dark,
				macchiato = override_dark,
				mocha = override_dark,
				latte = override_light,
			},
		},
	},

	{
		"akinsho/bufferline.nvim",
		dependencies = { { "catppuccin/nvim", name = "catppuccin" } },
		optional = true,

		opts = function(_, opts)
			local catppuccin_bufferline = require("catppuccin.groups.integrations.bufferline")

			opts.highlights = catppuccin_bufferline.get({
				styles = { "bold" },
				custom = {
					frappe = override_bufferline_hls(colors_get("frappe")),
					macchiato = override_bufferline_hls(colors_get("macchiato")),
					mocha = override_bufferline_hls(colors_get("mocha")),
					latte = override_bufferline_hls(colors_get("latte")),
				},
			})
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { { "catppuccin/nvim", name = "catppuccin" } },
		optional = true,

		opts = function(_, opts)
			opts.options.theme = lualine_theme_create(colors_get())

			vim.api.nvim_create_autocmd("ColorScheme", {
				desc = "Setup lualine theme after colorscheme changed",
				callback = vim.schedule_wrap(function()
					require("lualine").setup({
						options = { theme = lualine_theme_create(colors_get()) },
					})
				end),
			})
		end,
	},

	{
		"goolord/alpha-nvim",
		dependencies = { { "catppuccin/nvim", name = "catppuccin" } },
		optional = true,

		init = function()
			vim.api.nvim_create_autocmd("User", {
				once = true,
				pattern = "AlphaReady",
				callback = alpha_header_animate,
			})
		end,
	},

	{
		"folke/tokyonight.nvim",
		enabled = false,
	},
}
