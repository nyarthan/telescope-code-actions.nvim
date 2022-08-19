local pickers = require("telescope.pickers")
local finders = require("telescope.finders")

local U = require("telescope-code-actions.utils")

local open_menu = function(opts)
	opts = opts or {}

	local actions = U.get_code_actions()

	pickers
		.new(opts, {
			prompt_title = "Code Actions",
			finder = finders.new_table({
				results = actions,
			}),
		})
		:find()
end

return require("telescope").register_extension({
	-- setup = function(ext_config, config) end,
	exports = {
		code_actions = open_menu,
	},
})
