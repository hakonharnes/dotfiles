local colors = require("colors")
local WORKSPACE_ITEMS = {}

local function exec(cmd)
	local handle = io.popen(cmd)

	if not handle then
		return ""
	end

	local output = handle:read("*a")
	handle:close()

	return output or ""
end

-- Parse the `workspace|is-focused|monitor-id` format into a focused set and a
-- monitor map. Shared by the synchronous init path and the async refresh.
local function parse_meta(out)
	local order, focused, monitor = {}, {}, {}
	for line in (out or ""):gmatch("[^\n]+") do
		local ws, foc, mon = line:match("^([^|]*)|([^|]*)|([^|]*)$")
		if ws then
			table.insert(order, ws)
			focused[ws] = foc == "true"
			monitor[ws] = mon
		end
	end
	return order, focused, monitor
end

local function parse_non_empty(out)
	local set = {}
	for line in (out or ""):gmatch("[^\n]+") do
		set[line:match("^%s*(.-)%s*$")] = true
	end
	return set
end

local META_CMD = "aerospace list-workspaces --all --format "
	.. "'%{workspace}|%{workspace-is-focused}|%{monitor-appkit-nsscreen-screens-id}'"
local NON_EMPTY_CMD = "aerospace list-workspaces --monitor all --empty no"

local function apply(focused, monitor, non_empty)
	for workspace, space in pairs(WORKSPACE_ITEMS) do
		local is_focused = focused[workspace] == true
		local is_non_empty = non_empty[workspace] == true
		local is_visible = is_focused or is_non_empty

		space:set({
			label = {
				drawing = is_visible,
				highlight = is_focused,
			},
			padding_left = is_visible and 3 or 0,
			padding_right = is_visible and 3 or 0,
			associated_display = monitor[workspace],
			click_script = "aerospace workspace " .. workspace,
		})
	end
end

-- Async refresh: both queries run off the SbarLua event-loop thread, so a
-- workspace switch never blocks the bar. The two are fired in parallel and
-- joined once both land. Closure-local state means overlapping refreshes (from
-- rapid switches) can't clobber each other; SbarLua callbacks are cooperative
-- on one thread, so `pending` needs no locking.
local function update_workspace_items()
	local focused, monitor, non_empty
	local pending = 2

	local function done()
		pending = pending - 1
		if pending == 0 then
			apply(focused, monitor, non_empty)
		end
	end

	sbar.exec(META_CMD, function(meta_out)
		local _
		_, focused, monitor = parse_meta(meta_out)
		done()
	end)

	sbar.exec(NON_EMPTY_CMD, function(empty_out)
		non_empty = parse_non_empty(empty_out)
		done()
	end)
end

local function init()
	-- Item creation must be synchronous: items have to exist before we can
	-- subscribe or apply state. This runs once at bar startup.
	local order, _, monitor = parse_meta(exec(META_CMD))

	for _, workspace in ipairs(order) do
		WORKSPACE_ITEMS[workspace] = sbar.add("item", "space." .. workspace, {
			icon = { drawing = false },
			label = {
				string = workspace,
				color = colors.grey,
				highlight_color = colors.white,
			},
			padding_left = 3,
			padding_right = 3,
			associated_display = monitor[workspace],
		})
	end

	-- Single global listener: any workspace/focus change refreshes all items.
	local first_workspace = order[1]
	if first_workspace and WORKSPACE_ITEMS[first_workspace] then
		WORKSPACE_ITEMS[first_workspace]:subscribe("aerospace_focus_change", update_workspace_items)
	end

	update_workspace_items()
end

init()
