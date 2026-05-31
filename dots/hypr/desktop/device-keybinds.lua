-- KEYBIND: CONTROL + 0-9 → Focus Workspace
-- KEYBIND: CONTROL + SHIFT + 0-9 → Move Window to Workspace
-- KEYBINDS_SKIP_START
for i = 1, 10 do
	local key = i % 10
	hl.bind("CONTROL + " .. key, hl.dsp.focus({ workspace = i })) -- Move to i Workspace
	hl.bind("CONTROL + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end
-- KEYBINDS_SKIP_END
