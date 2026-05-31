for i = 1, 10 do
	local key = i % 10
	hl.bind("CONTROL + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind("CONTROL + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end
