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

	local apply = function(resolved_action)
		local command = resolved_action.command
		local edit = resolved_action.edit

		if command then
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

	if
		not self.server_action.edit
		and client
		and vim.tbl_get(client.server_capabilities, "codeActionProvider", "resolveProvider")
	then
		client.request("codeAction/resolve", self.server_action, function(err, resolved_action)
			if err then
				vim.notify(err.code .. ": " .. err.message, vim.log.levels.ERROR)
				return
			end

			apply(resolved_action)
		end)
	else
		apply(self.server_action)
	end
end

return CodeAction
