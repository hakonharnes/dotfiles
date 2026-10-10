local icons = require("icons")

local battery = sbar.add("item", {
	position = "right",
	update_freq = 120,
	label = { drawing = true },
})

local function battery_update()
	sbar.exec("pmset -g batt", function(batt_info)
		local percentage = tonumber(string.match(batt_info, "(%d+)%%"))
		-- Only while actually charging: plugged in but full reports "charged" or
		-- "AC attached; not charging". Plain-text find, so "discharging" can't match.
		local charging = string.find(batt_info, "; charging;", 1, true)
			or string.find(batt_info, "finishing charge", 1, true)
		local icon = icons.battery._0

		if percentage then
			if percentage >= 90 then
				icon = icons.battery._100
			elseif percentage >= 60 then
				icon = icons.battery._75
			elseif percentage >= 30 then
				icon = icons.battery._50
			elseif percentage >= 10 then
				icon = icons.battery._25
			else
				icon = icons.battery._0
			end
		end

		if charging then
			icon = icons.battery.charging
		end

		battery:set({
			icon = icon,
			label = percentage and (percentage .. "%") or "",
		})
	end)
end

battery:subscribe({ "routine", "power_source_change", "system_woke" }, battery_update)
