--[[

links:
CodeAction interface
https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#codeAction

--]]

local CodeAction = require("telescope-code-actions.models.code_action")

local M = {}

M.notify = function(msg, level, opts)
	local message = "[telescope-code-actions]: " .. msg

	---@diagnostic disable-next-line: redundant-parameter
	vim.notify(message, level or vim.log.levels.INFO, opts)
end

M.resolve_code_action = function(client, code_action)
	local res = client.request_sync("codeAction/resolve", code_action)
	return res
end

M.get_code_actions = function(bufnr)
	local clients = vim.lsp.buf_get_clients()

	if not clients then
		M.notify("No clients attached to this buffer!", vim.log.levels.ERROR)
		return
	end

	local code_actions = {}

	local method = "textDocument/codeAction"
	local params = vim.lsp.util.make_range_params()
	params.context = {
		diagnostics = vim.lsp.diagnostic.get_line_diagnostics(),
	}

	local server_actions = vim.lsp.buf_request_sync(bufnr, method, params)
	for client_id, item in pairs(server_actions) do
		local result = item.result
		local error = item.error

		if error ~= nil and error.code == -32601 then
			M.notify("Current LSP server has no code actions method", vim.log.levels.ERROR)
		end

		if error then
			return nil
		end

		if result == nil then
			return {}
		end

		for _, action in pairs(result) do
			table.insert(code_actions, CodeAction:new(action, { client_id = client_id, bufnr = bufnr }))
		end
	end

	return code_actions
end

return M
