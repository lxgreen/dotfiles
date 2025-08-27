local M = {}

-- Path to the inverses data file
local data_file = vim.fn.stdpath("config") .. "/data/inverses.json"

-- Ensure data directory exists
local function ensure_data_dir()
	local data_dir = vim.fn.stdpath("config") .. "/data"
	if vim.fn.isdirectory(data_dir) == 0 then
		vim.fn.mkdir(data_dir, "p")
	end
end

-- Read inverses from JSON file
local function read_inverses_file()
	ensure_data_dir()
	
	if vim.fn.filereadable(data_file) == 0 then
		-- If file doesn't exist, create it with default values
		local default_inverses = {
			["!="] = "==",
			["!=="] = "===",
			["+"] = "-",
			["<"] = ">",
			["<="] = ">=",
			["add"] = "remove",
			["all"] = "none",
			["before"] = "after",
			["const"] = "let",
			["desktop"] = "mobile",
			["enable"] = "disable",
			["every"] = "some",
			["first"] = "last",
			["from"] = "to",
			["global"] = "local",
			["increment"] = "decrement",
			["left"] = "right",
			["next"] = "prev",
			["on"] = "off",
			["open"] = "close",
			["public"] = "private",
			["split"] = "join",
			["start"] = "end",
			["top"] = "bottom",
			["true"] = "false",
			["up"] = "down",
			["yes"] = "no",
		}
		write_inverses_file(default_inverses)
		return default_inverses
	end
	
	local content = vim.fn.readfile(data_file)
	local json_string = table.concat(content, "\n")
	
	local ok, inverses = pcall(vim.json.decode, json_string)
	if not ok then
		vim.notify("Error reading inverses file: " .. inverses, vim.log.levels.ERROR)
		return {}
	end
	
	return inverses or {}
end

-- Write inverses to JSON file
function write_inverses_file(inverses)
	ensure_data_dir()
	
	local ok, json_string = pcall(vim.json.encode, inverses)
	if not ok then
		return false, "Error encoding JSON: " .. json_string
	end
	
	-- Pretty print JSON with proper indentation
	local formatted_json = json_string:gsub(",", ",\n  "):gsub("{", "{\n  "):gsub("}", "\n}")
	
	local lines = vim.split(formatted_json, "\n")
	local success = pcall(vim.fn.writefile, lines, data_file)
	
	if not success then
		return false, "Error writing to file"
	end
	
	return true, "Successfully saved inverses"
end

-- Function to add a new inverse mapping (persistently)
function M.add_inverse(word1, word2)
	if not word1 or not word2 or word1 == "" or word2 == "" then
		return false, "Both words must be non-empty"
	end
	
	-- Read current inverses from file
	local inverses = read_inverses_file()
	
	-- Add only the single direction mapping
	inverses[word1] = word2
	
	-- Write back to file
	local success, message = write_inverses_file(inverses)
	if not success then
		return false, message
	end
	
	return true, "Added inverse mapping: " .. word1 .. " → " .. word2
end

-- Function to get all inverses
function M.get_inverses()
	return read_inverses_file()
end

return M
