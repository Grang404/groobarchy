hl.config({
	general = {
		gaps_in = 0,
		gaps_out = 6,
		border_size = 1,
		col = {
			active_border = "rgba(757581ff)",
			inactive_border = "rgba(131314ff)",
		},

		resize_on_border = true,
		allow_tearing = false,
		layout = "dwindle",
	},
	hl.config({
		dwindle = {
			force_split = 2,
			smart_resizing = false,
			split_width_multiplier = 0.5,
			use_active_for_splits = true,
			default_split_ratio = 1.0,
			split_bias = 0,
		},
	}),

	decoration = {
		rounding = 5,
		rounding_power = 2,
		active_opacity = 1,
		inactive_opacity = 1,

		shadow = {
			enabled = false,
		},

		blur = {
			enabled = false,
			ignore_opacity = true,
			size = 2,
			passes = 2,
			vibrancy = 0.1696,
		},
	},
})
