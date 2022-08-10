local M = {}

M.map = function(table, cb)
	local t = {}
	for k, v in pairs(table) do
		t[k] = cb(v)
	end
	return t
end

M.normalize_server_actions = function(server_actions)
	local result = server_actions.result

	if result == nil then
		vim.notify(server_actions.err.message, vim.log.levels.ERROR)
		return nil
	end

	return result
end

M.get_server_code_actions = function(client)
	local params = vim.lsp.util.make_range_params()
	params.context = {
		diagnostics = vim.lsp.diagnostic.get_line_diagnostics(),
	}
	local server_actions = client.request_sync("textDocument/codeAction", params)
	local edits = M.normalize_server_actions(server_actions)
	return edits
end

M.get_code_actions = function()
	local lsp_clients = vim.lsp.buf_get_clients()
	local titles = {}
	M.map(lsp_clients, function(client)
		local edits = M.get_server_code_actions(client)
		for _, v in pairs(edits) do
			table.insert(titles, v.title)
		end
	end)
	return titles
end

return M
