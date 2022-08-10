local pickers = require("telescope.pickers")
local finders = require("telescope.finders")

print("this extension is loaded")

local open_menu = function(opts)
	opts = opts or {}

	pickers
		.new(opts, {
			prompt_title = "Code Actions",
			finder = finders.new_table({
				results = { "hi", "second hi" },
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
