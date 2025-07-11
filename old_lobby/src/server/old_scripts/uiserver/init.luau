--// By @ThatOneTusk
-- Handles UI remote calls

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UiServer = {
	LoadedComponents = {},
}

local LoadedComponents = UiServer.LoadedComponents
local UiCommunication = ReplicatedStorage.Events.UiCommunication

--// Listen for the UiCommunication remote. Path format: ComponentName/MethodName
function UiServer:start()
	--// Load all the components
	for _, module in script:GetChildren() do
		if module:IsA("ModuleScript") then
			task.spawn(function()
				LoadedComponents[module.Name] = require(module)
			end)
		end
	end

	UiCommunication.OnServerEvent:Connect(function(player, path: string, ...: any?)
		UiServer:RunComponentMethod(player, path, ...)
	end)
end

--// Attempts to call a method with the given path. Path format: ComponentName/MethodName
function UiServer:RunComponentMethod(player: Player, path: string, ...: any?)
	local TranslatedPath = string.split(path, "/")
	local ComponentName, Method = TranslatedPath[1], TranslatedPath[2]

	assert(ComponentName, "No Component name")
	assert(
		Method,
		`No Method found. Path may be incorrect. Path given: {path}, correct format: ComponentName/MethodName`
	)

	local FoundComponent = LoadedComponents[ComponentName]

	assert(FoundComponent, `Component {ComponentName} doesn't exist or didn't load properly`)
	assert(
		type(FoundComponent[Method]) == "function",
		`Method {Method} of Component {ComponentName} doesn't exist or isn't a valid function`
	)

	FoundComponent[Method](player, ...)
end

return UiServer
