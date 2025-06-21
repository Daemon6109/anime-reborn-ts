-------------------------------------------------------------------------------
-- loadModules
--------------------------------------------------------------------------------

--[=[
    Provides utility functions for loading ModuleScripts from instances.

    @class loadModules
]=]
local loadModules = {}

--[=[
    Loads all ModuleScripts from the children of the given source instance.

    @within loadModules
    @method fromChildren
    @param source Instance -- The instance whose children will be checked for ModuleScripts.
    @return { [string]: any } -- A dictionary where the keys are the names of the ModuleScripts and the values are the required modules.

    ```lua
    local modules = loadModules:fromChildren(source)
    ```
]=]
function loadModules:fromChildren(source: Instance): { [string]: any }
	local modules = {}

	for _, module in source:GetChildren() do
		if not module:IsA("ModuleScript") then
			continue
		end
		modules[module.Name] = require(module) :: any
	end

	return modules
end

--[=[
    Loads all ModuleScripts from the descendants of the given source instance.

    @within loadModules
    @method fromDescendants
    @param source Instance -- The instance whose descendants will be searched for ModuleScripts.
    @return { [string]: any } -- A dictionary where the keys are the names of the ModuleScripts and the values are the required modules.

    ```lua
    local modules = loadModules:fromDescendants(source)
    ```
]=]
function loadModules:fromDescendants(source: Instance): { [string]: any }
	local modules = {}

	for _, module in source:GetDescendants() do
		if not module:IsA("ModuleScript") then
			continue
		end
		modules[module.Name] = require(module) :: any
	end

	return modules
end

return loadModules
