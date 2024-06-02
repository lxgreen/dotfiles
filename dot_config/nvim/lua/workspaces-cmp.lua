local source = {}

local WS = require("get-workspaces")
source._items = vim.tbl_map(function(repo)
	return {
		label = repo,
		kind = vim.lsp.protocol.CompletionItemKind["Module"],
		insertText = repo,
		sortText = repo,
	}
end, WS.getWorkspaces())
local isComplete = false

source.complete = function(self, params, callback)
	if not isComplete then
		return callback({ items = source._items, isIncomplete = true })
	end
end

source.resolve = function(self, item, callback)
	isComplete = true
	return callback(item)
end

source.get_trigger_characters = function()
	if not isComplete then
		return { "[" }
	end
	return {}
end

return source
