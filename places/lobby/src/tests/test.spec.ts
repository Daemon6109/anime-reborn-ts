import { expect, describe, it } from "@rbxts/jest-globals";

describe("Sample tests", () => {
	it("should pass a basic test", () => {
		expect(1 + 1).toBe(2);
	});

	it("should test string operations", () => {
		const greeting = "Hello, Roblox!";
		expect(greeting).toBeDefined();
		expect(greeting.size()).toBeGreaterThan(0);
	});

	it("should test array operations", () => {
		const numbers = [1, 2, 3, 4, 5];
		expect(numbers).toHaveLength(5);
		expect(numbers[0]).toBe(1);
	});

	it("should test math calculations", () => {
		const multiplication = 5 * 5;
		const division = 10 / 2;
		expect(multiplication).toBe(25);
		expect(division).toBe(5);
	});
});

describe("Additional tests", () => {
	it("should handle boolean logic", () => {
		const isReady = true;
		const hasPermission = true;
		const andResult = isReady && hasPermission;
		
		const hasError = false;
		const hasBackup = true;
		const orResult = hasError || hasBackup;
		
		expect(andResult).toBe(true);
		expect(orResult).toBe(true);
	});
});
