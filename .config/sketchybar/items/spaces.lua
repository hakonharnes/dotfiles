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

-- Last state sent to each workspace item. A switch usually changes only a few
-- items, so unchanged ones are skipped instead of re-sending all of them.
local LAST_STATE = {}

local function apply(focused, monitor, non_empty)
	for workspace, space in pairs(WORKSPACE_ITEMS) do
		local is_focused = focused[workspace] == true
		local is_non_empty = non_empty[workspace] == true
		local is_visible = is_focused or is_non_empty
		local display = monitor[workspace]

		local last = LAST_STATE[workspace]
		if not last or last.focused ~= is_focused or last.visible ~= is_visible or last.display ~= display then
			LAST_STATE[workspace] = { focused = is_focused, visible = is_visible, display = display }
			space:set({
				label = {
					drawing = is_visible,
					highlight = is_focused,
				},
				padding_left = is_visible and 3 or 0,
				padding_right = is_visible and 3 or 0,
				associated_display = display,
			})
		end
	end
end

-- Incremented per refresh, so results from a superseded refresh are dropped.
local generation = 0

-- Async refresh: both queries run off the SbarLua event-loop thread, so a
-- workspace switch never blocks the bar. The two are fired in parallel and
-- joined once both land. On rapid switches an older refresh can finish after a
-- newer one, so only the latest refresh applies its results. SbarLua callbacks
-- are cooperative on one thread, so `pending` and `generation` need no locking.
local function update_workspace_items()
	local focused, monitor, non_empty
	local pending = 2
	generation = generation + 1
	local this_generation = generation

	local function done()
		pending = pending - 1
		if pending == 0 and this_generation == generation then
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
			click_script = "aerospace workspace " .. workspace,
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
