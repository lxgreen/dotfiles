local sbar = require("sketchybar")
local colors = require("colors")
local app_icons = require("helpers.app_icons")

local cursor = sbar.add("item", "widgets.cursor", {
	icon = {
		string = app_icons["Cursor"],
		font = "sketchybar-app-font:Regular:14.0",
	},
	label = {
		width = 0,
		padding_left = 0,
		padding_right = 8,
		color = colors.grey,
		font = {
			size = 10.0,
		},
	},
	padding_left = 0,
	padding_right = 4,
	position = "right",
	display = "active",
	update_freq = 300, -- Update every 5 minutes
})

-- Function to calculate days until next refresh
local function days_until_refresh(start_of_month)
	local start_date = os.time({
		year = tonumber(string.sub(start_of_month, 1, 4)),
		month = tonumber(string.sub(start_of_month, 6, 7)),
		day = tonumber(string.sub(start_of_month, 9, 10)),
		hour = tonumber(string.sub(start_of_month, 12, 13)),
		min = tonumber(string.sub(start_of_month, 15, 16)),
		sec = tonumber(string.sub(start_of_month, 18, 19)),
	})

	-- Calculate next refresh date (same day next month)
	local next_refresh_date = os.date("*t", start_date)
	next_refresh_date.month = next_refresh_date.month + 1
	if next_refresh_date.month > 12 then
		next_refresh_date.month = 1
		next_refresh_date.year = next_refresh_date.year + 1
	end
	-- Keep the same day and time as the original start date
	next_refresh_date.hour = 0
	next_refresh_date.min = 0
	next_refresh_date.sec = 0

	local next_refresh = os.time(next_refresh_date)
	local current_time = os.time()
	local days_left = math.ceil((next_refresh - current_time) / (24 * 60 * 60))

	return math.max(0, days_left)
end

-- Function to determine color based on average requests per day
local function C(days_until_count_reset, count_requests)
	local MAX_QUOTA = 500
	local remaining_requests = MAX_QUOTA - count_requests

	-- Calculate average requests per day available
	local avg_requests_per_day = remaining_requests / math.max(days_until_count_reset, 1)

	-- Reference point: 500 requests / 30 days = ~16.67 requests/day (yellow)
	local reference_avg = 500 / 30 -- ~16.67 requests per day

	-- Color thresholds based on average requests per day
	-- Green: > 20 req/day (plenty of room)
	-- Yellow: 10-20 req/day (normal usage)
	-- Orange: 5-10 req/day (getting tight)
	-- Red: < 5 req/day (very tight)

	local color
	if avg_requests_per_day >= 20 then
		-- Green: plenty of room
		color = colors.green
	elseif avg_requests_per_day >= 10 then
		-- Yellow: normal usage range
		color = colors.yellow
	elseif avg_requests_per_day >= 5 then
		-- Orange: getting tight
		color = colors.orange
	else
		-- Red: very tight
		color = colors.red
	end

	return color
end

-- Function to fetch cursor usage data with authentication error handling
local function fetch_usage_data()
	-- Use curl with error handling to detect authentication issues
	local curl_cmd = [[curl -s -w "%{http_code}" 'https://cursor.com/api/usage?user=user_01JDMZAZD6NWJ2NDQ2J26RNB7D' \
		-H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:144.0) Gecko/20100101 Firefox/144.0' \
		-H 'Accept: */*' \
		-H 'Accept-Language: en-US,en;q=0.5' \
		-H 'Accept-Encoding: gzip, deflate, br, zstd' \
		-H 'Referer: https://cursor.com/dashboard?tab=usage' \
		-H 'DNT: 1' \
		-H 'Connection: keep-alive' \
		-H 'Cookie: WorkosCursorSessionToken=user_01JDMZAZD6NWJ2NDQ2J26RNB7D%3A%3AeyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJnaXRodWJ8dXNlcl8wMUpETVpBWkQ2TldKMk5EUTJKMjZSTkI3RCIsInRpbWUiOiIxNzU2Mjk2OTM4IiwicmFuZG9tbmVzcyI6IjE4ZTQyNmU0LTVlMDctNDE1NSIsImV4cCI6MTc2MTQ4MDkzOCwiaXNzIjoiaHR0cHM6Ly9hdXRoZW50aWNhdGlvbi5jdXJzb3Iuc2giLCJzY29wZSI6Im9wZW5pZCBwcm9maWxlIGVtYWlsIG9mZmxpbmVfYWNjZXNzIiwiYXVkIjoiaHR0cHM6Ly9jdXJzb3IuY29tIiwidHlwZSI6IndlYiJ9._GnI9qXaTn7VLi-4W2p-DdmQ5m7CzcQSiXp3OROPBvg; generaltranslation.locale-routing-enabled=true; NEXT_LOCALE=en-US; generaltranslation.referrer-locale=en; GCLB="1300fb9f89cbe9ff'
		-H 'Sec-Fetch-Dest: empty' \
		-H 'Sec-Fetch-Mode: cors' \
		-H 'Sec-Fetch-Site: same-origin' \
		-H 'Sec-GPC: 1' \
		-H 'Priority: u=4' \
		-H 'Pragma: no-cache' \
		-H 'Cache-Control: no-cache' | jq -r '"\(."gpt-4"."numRequests"),\(."gpt-4"."maxRequestUsage" // 500),\(."startOfMonth")"']]

	local file = io.popen(curl_cmd)
	if not file then
		return { error = "network_error" }
	end

	local response = file:read("*a"):gsub("%s+", "")
	file:close()

	-- Check for authentication errors
	if response == "" or response == "null,null,null" then
		return { error = "auth_error" }
	end

	-- Parse the comma-separated response from jq
	local parts = {}
	for part in response:gmatch("[^,]+") do
		table.insert(parts, part)
	end

	if #parts < 3 then
		return { error = "parse_error" }
	end

	return {
		used_requests = tonumber(parts[1]) or 0,
		max_requests = tonumber(parts[2]) or 500,
		start_of_month = parts[3],
	}
end

-- Function to launch browser authentication
local function launch_browser_auth()
	-- Open Cursor dashboard in default browser
	sbar.exec("open 'https://cursor.com/dashboard?tab=usage'")
end

-- Function to update cursor widget
local function update()
	local data = fetch_usage_data()
	if not data then
		-- Show network error state
		sbar.animate("sin", 10, function()
			cursor:set({
				icon = { color = colors.red },
				label = { string = "?", color = colors.red },
			})
		end)
		return
	end

	-- Handle authentication errors
	if data.error == "auth_error" or data == "network_error" then
		-- Show authentication required state (blue icon)
		sbar.animate("sin", 10, function()
			cursor:set({
				icon = { color = colors.blue },
				label = { string = "net", color = colors.blue },
			})
		end)
		return
	end

	-- Handle other errors
	if data.error then
		-- Show error state
		sbar.animate("sin", 10, function()
			cursor:set({
				icon = { color = colors.red },
				label = { string = "?", color = colors.red },
			})
		end)
		return
	end

	local used_requests = data.used_requests
	local max_requests = data.max_requests
	local start_of_month = data.start_of_month

	-- Calculate days until refresh
	local days_left = days_until_refresh(start_of_month)

	-- Determine color based on average requests per day
	local color = C(days_left, used_requests)

	-- Create display text
	local display_text = tostring(used_requests)

	-- Update widget
	sbar.animate("sin", 10, function()
		cursor:set({
			icon = { color = color },
			label = {
				string = display_text,
				color = color,
			},
		})
	end)
end

-- Function to show detailed info on click
local function show_details()
	local data = fetch_usage_data()
	-- Handle authentication errors - launch browser auth
	if data.error == "auth_error" then
		launch_browser_auth()
		return
	end
end

-- Subscribe to update events
cursor:subscribe({ "cursor_update", "update" }, update)
cursor:subscribe("mouse.clicked", show_details)
cursor:subscribe("mouse.clicked.right", function()
	sbar.exec("sketchybar --trigger cursor_update")
end)

-- Mouse hover functionality
cursor:subscribe("mouse.entered", function(env)
	sbar.animate("tanh", 30, function()
		cursor:set({
			label = {
				width = "dynamic",
			},
		})
	end)
end)

cursor:subscribe("mouse.exited", function(env)
	sbar.animate("tanh", 30, function()
		cursor:set({
			label = {
				width = 0,
			},
		})
	end)
end)

-- Initialize cursor widget after startup delay
sbar.exec("sleep 2 && sketchybar --trigger cursor_update")

-- Manual trigger for immediate cursor check: sketchybar --trigger cursor_update

return cursor
