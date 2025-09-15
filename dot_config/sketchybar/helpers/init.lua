-- Add the sketchybar module to the package cpath
package.cpath = package.cpath .. ";/Users/" .. os.getenv("USER") .. "/.local/share/sketchybar_lua/?.so"

-- Pre-compiled binaries - compilation removed from startup for performance
-- Run 'make' manually in helpers/ directory if you need to recompile
-- os.execute("(cd helpers && make)")
