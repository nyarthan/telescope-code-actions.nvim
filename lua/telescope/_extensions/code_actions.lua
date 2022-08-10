local pickers = require("telescope.pickers")
local finders = require("telescope.finders")

local U = require("telescope-code-actions.utils")

local open_menu = function(opts)
	opts = opts or {}

	U.get_code_actions()

	pickers
		.new(opts, {
			prompt_title = "Code Actions",
			finder = finders.new_table({
				results = U.get_code_actions(),
			}),
		})
		:find()
end

return require("telescope").register_extension({
	-- setup = function(ext_config, config) end,
	exports = {
		open = open_menu,
	},
})
