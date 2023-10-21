-- Configuration
local debugMode = true;

-- Define a table of DEFCON levels and associated sound paths
local defconLevels = {
   { level = 1, sound = "notifications/ping.ogg" },
   { level = 2, sound = "notifications/ping.ogg" },
   { level = 3, sound = "notifications/ping.ogg" },
   { level = 4, sound = "notifications/ping.ogg" },
   { level = 5, sound = "notifications/ping.ogg" },
}

if debugMode then
   print("[nuhm] Events has been loaded!")
end
