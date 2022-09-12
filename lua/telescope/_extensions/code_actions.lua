local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local make_entry = require("telescope.make_entry")
local entry_display = require("telescope.pickers.entry_display")
local conf = require("telescope.config").values
local icons = require("telescope-code-actions.icons")

local U = require("telescope-code-actions.utils")

local open_menu = function(opts)
	opts = opts or {}

	local code_actions = U.get_code_actions(0)

	if code_actions == nil then
		return
	end

	local make_display = function(entry)
		local displayer = entry_display.create({
			separator = " ",
			items = {
				{ width = 1 },
				{ width = #entry.server_action.title },
			},
		})

		return displayer({
			{ icons.kind[entry.server_action.kind] },
			{ entry.server_action.title },
		})
	end

	pickers
		.new(opts, {
			prompt_title = "Code Actions",
			finder = finders.new_table({
				results = code_actions,
				entry_maker = function(entry)
					entry.value = entry
					entry.ordinal = entry.server_action.title
					entry.display = make_display
					return make_entry.set_default_entry_mt(entry, opts)
				end,
				sorter = conf.generic_sorter(opts),
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

return require("telescope").register_extension({
	-- setup = function(ext_config, config) end,
	exports = {
		code_actions = open_menu,
	},
})
