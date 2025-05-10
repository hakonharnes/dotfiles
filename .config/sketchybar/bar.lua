local colors = require("colors")

sbar.bar({
	height = 32,
	color = colors.bar.bg,
	sticky = true,
	padding_right = 10,
	padding_left = 10,
	blur_radius = 30,
	topmost = "window",
})
