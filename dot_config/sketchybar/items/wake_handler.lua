-- Wake handler: recover the bar after a sleep/wake cycle.
--
-- Root cause of the old "frozen until `brew services restart`" bug:
-- the previous handler fired a burst of *racing* async shell commands on wake
-- (killall cpu_load/network_load; delayed respawn &; forced `sketchybar --update`),
-- while the separate theme-detector daemon could fire `sketchybar --reload` in the
-- same window. Several uncoordinated mutations hitting sketchybar's single-threaded
-- mach event loop during the fragile post-wake window deadlocked the server. It hung
-- (never crashed), so launchd's KeepAlive never relaunched it -> a manual full restart
-- was the only recovery.
--
-- Fix: on wake, do exactly ONE thing -- a single, settle-delayed `sketchybar --reload`,
-- debounced via a shared lock so it can never stack with itself or with a theme reload.
-- `--reload` re-runs the config, and items/widgets/cpu.lua + items/widgets/wifi.lua
-- already `killall` their provider before respawning it, so the providers come back
-- cleanly with no duplicates. No killall race, no forced --update racing the respawn.

local sbar = require("sketchybar")

-- Keep this window in sync with DEBOUNCE_SECS in helpers/auto_theme_detector_safe.sh.
local DEBOUNCE_SECS = 20

-- One sequential shell script (NOT several racing execs). It debounces on a shared
-- lock file, waits for the system to settle, then does a single clean reload.
local function reload_bar_debounced(reason)
	sbar.exec(string.format(
		[[
		LOCK="$CONFIG_DIR/.reload.lock"
		LOG="$CONFIG_DIR/wake_handler.log"
		now=$(date +%%s)
		# Read the stored epoch back with cat (portable across BSD/GNU stat).
		last=$(cat "$LOCK" 2>/dev/null)
		case "$last" in ''|*[!0-9]*) last=0 ;; esac
		if [ $((now - last)) -lt %d ]; then
			echo "[$(date)] %s: skipped (debounced)" >> "$LOG"
			exit 0
		fi
		echo "$now" > "$LOCK"
		echo "[$(date)] %s: reloading after settle" >> "$LOG"
		sleep 3
		sketchybar --reload
		]],
		DEBOUNCE_SECS, reason, reason
	))
end

-- Hidden item that exists only to receive system power events.
local wake_handler = sbar.add("item", "wake_handler", {
	drawing = false,
	updates = true,
})

wake_handler:subscribe("system_woke", function(env)
	reload_bar_debounced("wake")
end)

wake_handler:subscribe("system_will_sleep", function(env)
	-- Just record it. Do NOT touch the providers here: the wake reload respawns them
	-- cleanly, and killing them on sleep only adds another moving part to the race.
	sbar.exec([[echo "[$(date)] system going to sleep" >> "$CONFIG_DIR/wake_handler.log"]])
end)

return wake_handler
