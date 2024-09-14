local ignore_patterns = {
	".git/",
	"node_modules/",
	".cache/",
	".next/",
	"messages_ar.json",
	"messages_bg.json",
	"messages_ca.json",
	"messages_cs.json",
	"messages_da.json",
	"messages_de.json",
	"messages_el.json",
	"messages_es.json",
	"messages_fi.json",
	"messages_fr.json",
	"messages_he.json",
	"messages_hi.json",
	"messages_hu.json",
	"messages_id.json",
	"messages_it.json",
	"messages_ja.json",
	"messages_ko.json",
	"messages_lt.json",
	"messages_ms.json",
	"messages_nl.json",
	"messages_no.json",
	"messages_pl.json",
	"messages_pt.json",
	"messages_ro.json",
	"messages_ru.json",
	"messages_sk.json",
	"messages_sl.json",
	"messages_sv.json",
	"messages_th.json",
	"messages_tl.json",
	"messages_tr.json",
	"messages_uk.json",
	"messages_vi.json",
	"messages_zh.json",
}

return {
	"ibhagwan/fzf-lua",
	config = function()
		local fzf_lua = require("fzf-lua")
		fzf_lua.setup({
			file_ignore_patterns = ignore_patterns,
			fzf_colors = true,
			winopts = {
				on_create = function()
					local function feedkeys(normal_key, insert_key)
						vim.keymap.set("n", normal_key, function()
							vim.api.nvim_feedkeys(
								vim.api.nvim_replace_termcodes("i", true, false, true) or "",
								"n",
								true
							)
							vim.api.nvim_feedkeys(
								vim.api.nvim_replace_termcodes(insert_key, true, false, true) or "",
								"n",
								true
							)
							vim.api.nvim_feedkeys(
								vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true) or "",
								"n",
								true
							)
						end, { nowait = true, noremap = true, buffer = vim.api.nvim_get_current_buf() })
					end
					feedkeys("j", "<c-n>")
					feedkeys("k", "<c-p>")
					feedkeys("f", "<c-f>")
					feedkeys("b", "<c-b>")
					feedkeys("q", "<Esc>")
				end,
			},
		})
	end,
}
