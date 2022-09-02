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

M.create_temp_file = function()
	return vim.fn.tempname()
end

M.resolve_code_action = function(client, code_action)
	local res = client.request_sync("codeAction/resolve", code_action)
	return res
end

M.get_code_actions = function()
	local clients = vim.lsp.buf_get_clients()

	if not clients then
		M.notify("No clients attached to this buffer!", vim.log.levels.ERROR)
		return
	end

	local code_actions = {}

	for _, client in pairs(clients) do
		local params = vim.lsp.util.make_range_params()
		params.context = {
			diagnostics = vim.lsp.diagnostic.get_line_diagnostics(),
		}
		local response = client.request_sync("textDocument/codeAction", params)

		local result = response.result
		local error = response.err

		if error then
			vim.notify(error)
			return nil
		end

		if result == nil then
			return nil
		end

		for _, server_action in pairs(result) do
			table.insert(
				code_actions,
				CodeAction:new(server_action, {
					client_id = client.id,
				})
			)
		end
	end

	return code_actions
end

return M
