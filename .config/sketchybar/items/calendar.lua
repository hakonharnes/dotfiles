local cal = sbar.add("item", {
	position = "right",
	icon = { drawing = false },
	update_freq = 30,
})

local function update()
	cal:set({ label = os.date("%a %b %e  %H:%M") })
end

cal:subscribe("routine", update)
cal:subscribe("forced", update)
