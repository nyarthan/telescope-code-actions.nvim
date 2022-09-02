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
		bufnr = nil,
	},
}

function CodeAction:new(server_action, meta)
	local instance = { server_action = server_action, meta = meta }
	setmetatable(instance, self)
	self.__index = self
	return instance
end

function CodeAction:apply()
	local client = vim.lsp.get_client_by_id(self.meta.client_id)
	local command = self.server_action.command
	local edit = self.server_action.edit
	if self.server_action.command then
		local params = {
			command = command.command,
			arguments = command.arguments,
			wordDoneToken = command.wordDoneToken,
		}
		client.request("workspace/executeCommand", params, nil, self.meta.bufnr)
	end
	if edit then
		vim.lsp.util.apply_workspace_edit(edit, client.offset_encoding)
	end
end

return CodeAction
