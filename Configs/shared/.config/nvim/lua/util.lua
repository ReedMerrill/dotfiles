local M = {}
M.is_tmux = os.getenv("TMUX") ~= nil

M.tmux_cmd = function(fmt)
	-- Run `tmux display-message -p '<fmt>'` and trim trailing newline
	local handle = io.popen("tmux display-message -p '" .. fmt .. "' 2>/dev/null")
	if not handle then
		return nil
	end
	local result = handle:read("*l")
	handle:close()
	return result
end

M.tmux_session = function()
	return M.tmux_cmd("#S") or ""
end

M.tmux_window = function()
	return M.tmux_cmd("#W") or ""
end

return M
