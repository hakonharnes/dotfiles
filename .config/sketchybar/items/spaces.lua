local colors = require("colors")
local WORKSPACE_ITEMS = {}

local function exec(cmd)
	local handle = io.popen(cmd)

	if not handle then
		return nil
	end

	local output = handle:read("*a")
	handle:close()

	return output:match("^%s*(.-)%s*$")
end

local function list_workspaces(args)
	local output = exec("aerospace list-workspaces " .. (args or ""))
	local result = {}

	for line in output:gmatch("([^\n]+)") do
		table.insert(result, line)
	end

	return result
end

local function get_focused_workspace()
	return exec("aerospace list-workspaces --focused")
end

local function get_non_empty_workspaces()
	local workspaces = list_workspaces("--monitor all --empty no")

	local result = {}
	for _, workspace in ipairs(workspaces) do
		result[workspace] = true
	end

	return result
end

local function get_workspace_to_monitor()
	local lines = list_workspaces('--all --format "%{workspace};%{monitor-id}"')
	local workspace_to_monitor = {}

	for _, line in ipairs(lines) do
		local workspace, monitor_id = line:match("^([^;]+);([^;]+)$")
		workspace_to_monitor[workspace] = monitor_id
	end

	return workspace_to_monitor
end

local function update_workspace_items(focused_workspace)
	local non_empty = get_non_empty_workspaces()
	local workspace_to_monitor = get_workspace_to_monitor()

	for workspace, space in pairs(WORKSPACE_ITEMS) do
		local is_focused = workspace == focused_workspace
		local is_non_empty = non_empty[workspace] == true
		local is_visible = is_focused or is_non_empty

		space:set({
			label = {
				drawing = is_visible,
				highlight = is_focused,
			},
			padding_left = is_visible and 3 or 0,
			padding_right = is_visible and 3 or 0,
			associated_display = workspace_to_monitor[workspace],
			click_script = "aerospace workspace " .. workspace,
		})
	end
end

local function init()
	local workspaces = list_workspaces("--all")
	local workspace_to_monitor = get_workspace_to_monitor()

	for _, workspace in ipairs(workspaces) do
		WORKSPACE_ITEMS[workspace] = sbar.add("item", "space." .. workspace, {
			icon = { drawing = false },
			label = {
				string = workspace,
				color = colors.grey,
				highlight_color = colors.white,
			},
			padding_left = 3,
			padding_right = 3,
			associated_display = workspace_to_monitor[workspace],
		})
	end

	local focused = get_focused_workspace()
	WORKSPACE_ITEMS[focused]:subscribe("aerospace_focus_change", function()
		local focused = get_focused_workspace()
		update_workspace_items(focused)
	end)

	update_workspace_items(focused)
end

init()
