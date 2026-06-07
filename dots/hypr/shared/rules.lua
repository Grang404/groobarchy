-- layerrule = blur on, match:namespace waybar

hl.layer_rule({
	match = { namespace = "rofi" },
	blur = true,
	ignore_alpha = 0.5,
})

hl.layer_rule({
	match = { namespace = "notifications" },
	blur = true,
	ignore_alpha = 0.5,
})

hl.window_rule({
	name = "steam",
	match = {
		class = "steam",
	},
	workspace = 4,
	no_initial_focus = true,
})

hl.window_rule({
	name = "steam-friends",
	match = {
		title = "Friends List",
	},
	workspace = 4,
	no_initial_focus = true,
	float = true,
	size = { 360, 680 },
	move = { 1538, 376 },
})

hl.window_rule({
	name = "discord",
	match = {
		class = "discord",
	},
	workspace = 8,
})

hl.window_rule({
	name = "pavu",
	match = {
		class = "org.pulseaudio.pavucontrol",
	},
	float = true,
	size = { 674, 484 },
	move = { 1241, 46 },
})

hl.window_rule({
	name = "suppress-maximize-events",
	match = {
		class = ".*",
	},
	suppress_event = "maximize",
})

hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})
