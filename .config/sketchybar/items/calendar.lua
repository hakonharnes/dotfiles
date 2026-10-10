local cal = sbar.add("item", {
	position = "right",
	icon = { drawing = false },
})

local function update()
	cal:set({ label = os.date("%a %b %e  %H:%M") })
end

-- Instead of polling, sleep until the next minute starts and update then.
-- Timers don't track wall time across sleep, so waking restarts the chain;
-- the generation check stops the previous chain from running alongside it.
local generation = 0

local function tick(gen)
	if gen ~= generation then
		return
	end
	update()
	sbar.delay(60 - tonumber(os.date("%S")), function()
		tick(gen)
	end)
end

local function restart()
	generation = generation + 1
	tick(generation)
end

cal:subscribe({ "forced", "system_woke" }, restart)
restart()
