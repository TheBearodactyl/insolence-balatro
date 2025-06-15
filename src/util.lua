local M = {}

--- @param path string
M.load = function(path)
    SMODS.load_file(path)()
end

return M
