local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GohanLimitData = DataStoreService:GetDataStore("GohanLimit")

local GohanLimitVariable = ReplicatedStorage.GameVariables.GohanLimit
local GohanObtainedVariable = ReplicatedStorage.GameVariables.GohanObtainedAmount

local module = {}

local DEFAULT_LIMIT = 10000

local Data = {}

function module:start()
	module:_UpdateData()

	coroutine.wrap(function()
		while task.wait(60) do
			module:_UpdateData()
		end
	end)()
end

function module:_UpdateData()
	local RetryDelay = 2

	for i = 1, 10 do
		RetryDelay *= 1.38

		local loadedData, err = pcall(function()
			local LimitNow = GohanLimitData:GetAsync("Limit")
			local ObtainedNow = GohanLimitData:GetAsync("Obtained")

			local NewData = {}

			if not LimitNow then
				GohanLimitData:SetAsync("Limit", DEFAULT_LIMIT)
				NewData.Limit = DEFAULT_LIMIT
			else
				NewData.Limit = LimitNow
			end

			if not ObtainedNow then
				GohanLimitData:SetAsync("Obtained", 0)
				NewData.Obtained = 0
			else
				NewData.Obtained = ObtainedNow
			end

			if NewData.Limit and NewData.Obtained then
				Data = NewData

				GohanLimitVariable.Value = NewData.Limit -- Unfortunately, this is due to a final minute change, so do not use these for actual checking, use GetLimit and GetObtainedAmount instead
				GohanObtainedVariable.Value = NewData.Obtained
			else
				error()
			end

			return true
		end)

		if loadedData then
			return
		end

		task.wait(RetryDelay)
	end
end

function module:GetLimit()
	if not Data.Limit then
		repeat
			task.wait()

		until Data.Limit
	end

	return Data.Limit
end

function module:GetObtainedAmount()
	if not Data.Obtained then
		repeat
			task.wait()

		until Data.Obtained
	end

	return Data.Obtained
end

function module:IncrementObtainedAmount()
	task.spawn(function()
		module:GetObtainedAmount() -- Ensure data loaded

		local RetryDelay = 2

		for i = 1, 10 do
			RetryDelay *= 1.38

			local saved, err = pcall(function()
				GohanLimitData:IncrementAsync("Obtained", 1)
			end)

			if saved then
				Data.Obtained += 1
				GohanObtainedVariable.Value = Data.Obtained

				return
			end

			task.wait(RetryDelay)
		end
	end)
end

return module
