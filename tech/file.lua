local file = {}

--- @param path string
--- @return string
file.read = function(path)
  local f = assert(io.open(path, "r"))
  local result = f:read("*a"):gsub("\n", " ")
  f:close()
  return result
end

return file
