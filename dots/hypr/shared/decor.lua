hl.config({
	general = {
		gaps_in = 3,
		gaps_out = 6,
		border_size = 1,
		col = {
			active_border = "rgba(757581ff)",
			inactive_border = "rgba(2a2a2dff)",
		},

		resize_on_border = true,
		allow_tearing = false,
		layout = "hy3",
	},

	decoration = {
		rounding = 5,
		rounding_power = 2,
		active_opacity = 1,
		inactive_opacity = 1,

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = "rgba(1a1a1aee)",
		},

		blur = {
			enabled = true,
			ignore_opacity = true,
			size = 2,
			passes = 2,
			vibrancy = 0.1696,
		},
	},
})
