--[=[
	Function to call and retry a given function, up to maxAttempts times.
	This function waits pauseConstant + (pauseExponent ^ numAttempts) between retries for progressive exponential backoff.
	Calls are made with the functionCallHandler (default: pcall)
	and the results of this (in the form of success, errorMessage or ...) are returned.
]=]

type Function = (...any) -> ...any
export type FunctionHandler = (...any) -> (boolean, ...any)

--[=[
    Attempts to execute a given function multiple times until it succeeds or the maximum number of attempts is reached.
    
    @param func Function -- The function to be executed.
    @param maxAttempts number -- The maximum number of attempts to execute the function.
    @param optionalPauseConstant number? -- An optional constant pause time between attempts (default is 0).
    @param optionalPauseExponent number? -- An optional exponent to increase the pause time between attempts (default is 0).
    @param optionalFunctionCallHandler ((Function) -> (boolean, ...any))? -- An optional handler function to call the provided function (default is pcall).
    
    @return (boolean, ...any) -- Returns a boolean indicating success, followed by the function's return values or an error message.

    ```lua
    local success, result = retryAsync(myFunction, 5, 1, 2)
    if success then
        print("Function succeeded with result:", result)
    else
        print("Function failed with error:", result)
    end
    ```
]=]
local function retryAsync(
	func: Function,
	maxAttempts: number,
	optionalPauseConstant: number?,
	optionalPauseExponent: number?,
	optionalFunctionCallHandler: ((Function) -> (boolean, ...any))?
): (boolean, ...any)
	-- Using separate variables to satisfy the type checker
	local pauseConstant: number = optionalPauseConstant or 0
	local pauseExponent: number = optionalPauseExponent or 0
	local functionCallHandler: FunctionHandler = optionalFunctionCallHandler or pcall

	local attempts = 0
	local success: boolean, result: { any }

	while attempts < maxAttempts do
		attempts = attempts + 1

		local returnValues: { any }

		returnValues = { functionCallHandler(func) }

		success = table.remove(returnValues, 1) :: boolean
		result = returnValues

		if success then
			break
		end

		local pauseTime = pauseConstant + (pauseExponent ^ attempts)

		if attempts < maxAttempts then
			task.wait(pauseTime)
		end
	end

	if success then
		return success, table.unpack(result)
	else
		local errorMessage = not success and result[1] :: any or nil
		return success, errorMessage :: any
	end
end

return retryAsync
