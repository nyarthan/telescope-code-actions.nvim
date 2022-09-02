local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local U = require("telescope-code-actions.utils")

local open_menu = function(opts)
	opts = opts or {}

	local code_actions = U.get_code_actions()

	if code_actions ~= nil then
		pickers
			.new(opts, {
				prompt_title = "Code Actions",
				finder = finders.new_table({
					results = code_actions,
					entry_maker = function(entry)
						return {
							value = entry,
							display = entry.server_action.title,
							ordinal = entry.server_action.title,
						}
					end,
				}),
				attach_mappings = function(prompt_bufnr, map)
					actions.select_default:replace(function()
						actions.close(prompt_bufnr)
						local selection = action_state.get_selected_entry()
						selection.value:apply()
					end)
					return true
				end,
			})
			:find()
	end
end

return require("telescope").register_extension({
	-- setup = function(ext_config, config) end,
	exports = {
		code_actions = open_menu,
	},
})
