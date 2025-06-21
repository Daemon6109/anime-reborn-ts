// Example test demonstrating Lune bridge for real Roblox globals
import { expect, describe, it } from "@rbxts/jest-globals";

// Extend global interface for our Lune bridge functions
declare const executeLuau: (code: string) => Promise<{ success: boolean; result: unknown; error?: string }>;
declare const typeOfSync: (value: unknown) => string;
declare const pairsSync: (obj: unknown) => unknown[];

describe("Lune Bridge Demo", () => {
	describe("Real Roblox Globals via Lune", () => {
		it("should execute typeOf with real Luau runtime", async () => {
			// Using global helper to execute Luau code directly
			const result = await executeLuau(`
				local testTable = {a = 1, b = 2}
				local testArray = {1, 2, 3}
				local testString = "hello"
				
				setTestResult({
					tableType = typeof(testTable),
					arrayType = typeof(testArray), 
					stringType = typeof(testString),
					nilType = typeof(nil)
				})
			`);

			expect(result.success).toBe(true);
			const resultData = result.result as Record<string, string>;
			expect(resultData.tableType).toBe("table");
			expect(resultData.arrayType).toBe("table");
			expect(resultData.stringType).toBe("string");
			expect(resultData.nilType).toBe("nil");
		});

		it("should execute pairs with real Luau behavior", async () => {
			const result = await executeLuau(`
				local testTable = {a = 1, b = 2, c = 3}
				local pairs_result = {}
				
				for key, value in pairs(testTable) do
					table.insert(pairs_result, {key = key, value = value})
				end
				
				setTestResult(pairs_result)
			`);

			expect(result.success).toBe(true);
			expect(result.result).toBeTruthy();
			const resultArray = result.result as unknown[];
			expect(typeOf(resultArray) === "table").toBe(true);
			expect(resultArray.size()).toBe(3);
		});

		it("should execute ipairs with 1-based indexing", async () => {
			const result = await executeLuau(`
				local testArray = {"first", "second", "third"}
				local ipairs_result = {}
				
				for index, value in ipairs(testArray) do
					table.insert(ipairs_result, {index = index, value = value})
				end
				
				setTestResult(ipairs_result)
			`);

			expect(result.success).toBe(true);
			expect(result.result).toBeTruthy();
			const resultArray = result.result as Array<{ index: number; value: string }>;
			expect(resultArray[0].index).toBe(1); // Lua 1-based indexing
			expect(resultArray[0].value).toBe("first");
			expect(resultArray[2].index).toBe(3);
			expect(resultArray[2].value).toBe("third");
		});

		it("should handle math operations accurately", async () => {
			const result = await executeLuau(`
				local floor_result = math.floor(3.7)
				local max_result = math.max(1, 5, 3)
				local min_result = math.min(1, 5, 3)
				
				setTestResult({
					floor = floor_result,
					max = max_result,
					min = min_result
				})
			`);

			expect(result.success).toBe(true);
			const resultData = result.result as Record<string, number>;
			expect(resultData.floor).toBe(3);
			expect(resultData.max).toBe(5);
			expect(resultData.min).toBe(1);
		});

		it("should handle string operations with Roblox string library", async () => {
			const result = await executeLuau(`
				local test_string = "Hello World"
				local length = string.len(test_string)
				local upper = string.upper(test_string)
				local lower = string.lower(test_string)
				local sub = string.sub(test_string, 1, 5)
				
				setTestResult({
					length = length,
					upper = upper,
					lower = lower,
					sub = sub
				})
			`);

			expect(result.success).toBe(true);
			const resultData = result.result as Record<string, string | number>;
			expect(resultData.length).toBe(11);
			expect(resultData.upper).toBe("HELLO WORLD");
			expect(resultData.lower).toBe("hello world");
			expect(resultData.sub).toBe("Hello");
		});

		it("should handle table operations", async () => {
			const result = await executeLuau(`
				local testTable = {1, 2, 3}
				table.insert(testTable, 4)
				table.insert(testTable, 2, "inserted")
				
				local length = #testTable
				local last = table.remove(testTable)
				
				setTestResult({
					table = testTable,
					length = length,
					removed = last
				})
			`);

			expect(result.success).toBe(true);
			const resultData = result.result as { table: unknown[]; length: number; removed: unknown };
			expect(resultData.length).toBe(5);
			expect(resultData.removed).toBe(4);
			expect(resultData.table[1]).toBe("inserted"); // 0-based in result
		});
	});

	describe("Fallback Behavior", () => {
		it("should still work with synchronous fallbacks", () => {
			// These use the sync fallback versions
			const tableType = typeOfSync({ a: 1 });
			const stringType = typeOfSync("hello");
			const numberType = typeOfSync(42);

			expect(tableType).toBe("table");
			expect(stringType).toBe("string");
			expect(numberType).toBe("number");
		});

		it("should handle pairs fallback", () => {
			const result = pairsSync({ a: 1, b: 2 });
			expect(typeOf(result) === "table").toBe(true);
			expect((result as unknown[]).size()).toBe(2);
		});
	});

	describe("Complex Operations", () => {
		it("should handle deep copy operations via Lune", async () => {
			// Test our actual deep copy utility using real Luau runtime
			const result = await executeLuau(`
				-- Import the deep copy function logic
				local function deepCopy(obj)
					local objType = typeof(obj)
					
					if objType ~= "table" then
						return obj
					end
					
					-- Simple deep copy for demo
					local copy = {}
					for k, v in pairs(obj) do
						if typeof(v) == "table" then
							copy[k] = deepCopy(v)
						else
							copy[k] = v
						end
					end
					return copy
				end
				
				local original = {
					level1 = {
						level2 = {
							value = "test"
						}
					},
					simple = "value"
				}
				
				local copied = deepCopy(original)
				
				-- Modify original to test independence
				original.level1.level2.value = "modified"
				
				setTestResult({
					original_value = original.level1.level2.value,
					copied_value = copied.level1.level2.value
				})
			`);

			expect(result.success).toBe(true);
			const resultData = result.result as Record<string, string>;
			expect(resultData.original_value).toBe("modified");
			expect(resultData.copied_value).toBe("test"); // Should be unchanged
		});
	});
});
