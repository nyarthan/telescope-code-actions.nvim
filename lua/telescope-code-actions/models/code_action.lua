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

return CodeAction
