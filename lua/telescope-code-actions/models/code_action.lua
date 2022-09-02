local CodeAction = {
	server_action = {
		title = nil,
		kind = nil,
		diagnostics = nil,
		isPreferred = nil,
		disabled = nil,
		edit = nil,
		command = nil,
		data = nil,
	},
	meta = {
		client_id = nil,
	},
}

function CodeAction:new(server_action, meta)
	local instance = { server_action = server_action, meta = meta }
	setmetatable(instance, self)
	self.__index = self
	return instance
end

function CodeAction:apply()
	if self.server_action.command then
		vim.lsp.util.execute_command(self.server_action.command)
	end
	if self.server_action.edit then
		print(vim.inspect(self.server_action.edit))
		---@diagnostic disable-next-line: undefined-field
		vim.lsp.util.apply_workspace_edit(self.server_action.edit, "utf-8")
	end
end

return CodeAction
