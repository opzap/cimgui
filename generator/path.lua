local M = {}

local sep = package.config:sub(1,1)

-- Function to resolve paths relative to the script directory
local function resolve_path(dir, path)
    local opposite_sep = (sep == "/") and "\\" or "/"
    -- Normalize separators in dir
    dir = dir:gsub(opposite_sep, sep)
    -- Normalize separators in path
    path = path:gsub(opposite_sep, sep)
    
    if path:sub(1, 1) == sep or (sep == "\\" and path:match("^%a:")) then
        -- Absolute path, return as is
        return path
    elseif path:sub(1, 2) == "." .. sep then
        -- Relative to current directory, resolve against dir
        return dir .. path:sub(3)
    elseif path:sub(1, 3) == ".." .. sep then
        -- Path going up directories, resolve carefully
        local result = dir
        local parts = {}
        for part in path:gmatch("[^" .. sep .. "]+") do
            table.insert(parts, part)
        end
        local i = 1
        while i <= #parts do
            if parts[i] == ".." then
                result = result:match("(.*" .. sep .. ")[^" .. sep .. "]+" .. sep .. "$")  -- Go up one directory
                i = i + 1
            else
                result = result .. parts[i] .. sep
                i = i + 1
            end
        end
        return result:sub(1, -2)  -- Remove trailing separator
    else
        -- Relative path without ./ prefix, assume relative to dir
        return dir .. path
    end
end

M.resolve = resolve_path

return M
