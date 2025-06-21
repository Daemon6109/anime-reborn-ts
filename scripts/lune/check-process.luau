-- Test what's available in Lune
local process = require("@lune/process")

print("Process module contents:")
for k, v in pairs(process) do
	print(k, type(v))
end
