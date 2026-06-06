-- KEYBIND: CONTROL + 0-9 → Focus Workspace
-- KEYBIND: CONTROL + SHIFT + 0-9 → Move Window to Workspace
-- KEYBINDS_SKIP_START
for i = 1, 10 do
	local key = i % 10
	hl.bind("CONTROL + " .. key, hl.dsp.focus({ workspace = i })) -- Move to i Workspace
	hl.bind("CONTROL + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end
-- KEYBINDS_SKIP_END

-- KEYBIND: Volume Up
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
-- KEYBIND: Volume Down
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
-- KEYBIND: Mute
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
-- KEYBIND: Mute Mic
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
-- KEYBIND: Brightness Up
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
-- KEYBIND: Brightness Down
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
-- KEYBIND: Next Track
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
-- KEYBIND: Play/Pause
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
-- KEYBIND: Play/Pause
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
-- KEYBIND: Previous Track
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
