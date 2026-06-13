-- KEYBIND: CONTROL + 1-5 → Focus Workspace 1-5
-- KEYBIND: ALT + 1-5 → Focus Workspace 6-10
-- KEYBIND: SUPER + K → Focus Workspace uwu
-- KEYBIND: CONTROL + SHIFT + 1-5 → Move Window to Workspace 1-5
-- KEYBIND: ALT + SHIFT + 1-5 → Move Window to Workspace 6-10
-- KEYBIND: CONTROL + SUPER + K → Move Window to Workspace uwu
-- KEYBINDS_SKIP_START
for i = 1, 5 do
	hl.bind("CONTROL + " .. i, hl.dsp.focus({ workspace = i }))
	hl.bind("ALT + " .. i, hl.dsp.focus({ workspace = i + 5 }))
	hl.bind("CONTROL + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
	hl.bind("ALT + SHIFT + " .. i, hl.dsp.window.move({ workspace = i + 5 }))
end

for i = 6, 10 do
	local key = (i == 10) and "0" or tostring(i)
	local ws = i + 5

	hl.bind("CONTROL + " .. key, hl.dsp.focus({ workspace = ws }))
	hl.bind("ALT + " .. key, hl.dsp.focus({ workspace = ws + 5 }))
	hl.bind("CONTROL + SHIFT + " .. key, hl.dsp.window.move({ workspace = ws }))
	hl.bind("ALT + SHIFT + " .. key, hl.dsp.window.move({ workspace = ws + 5 }))
end

hl.bind("SUPER + K", hl.dsp.focus({ workspace = "name:uwu" }))
hl.bind("CONTROL + SUPER + K", hl.dsp.window.move({ workspace = "name:uwu" }))
-- KEYBINDS_SKIP_END
