local process = require("@lune/process")
local serde = require("@lune/serde")

print("Script started")
print("Args:", serde.encode("json", process.args))
