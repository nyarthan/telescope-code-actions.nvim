--[[

links:
CodeAction interface
https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#codeAction

--]]

local M = {}

M.get_code_actions = function()
	local clients = vim.lsp.buf_get_clients()

	local actions = {}

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

		local titles = vim.tbl_map(function(item)
			return item.title
		end, result)

		for _, title in pairs(titles) do
			table.insert(actions, title)
		end
	end

	return actions
end

return M
