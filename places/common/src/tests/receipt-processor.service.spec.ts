import { expect, describe, it, beforeEach, jest } from "@rbxts/jest-globals";
import { ReceiptProcessorService, ProductCallback } from "server/services/receipt-processor.service";
import { DataService } from "server/services/data.service";

describe("ReceiptProcessorService", () => {
	let service: ReceiptProcessorService;
	let mockDataService: DataService;

	beforeEach(() => {
		jest.clearAllMocks();

		// Create mock DataService
		mockDataService = {
			getCache: jest.fn(),
			setCache: jest.fn(),
		} as unknown as DataService;

		service = new ReceiptProcessorService(mockDataService);
	});

	describe("Product Callback Registration", () => {
		it("should register product callbacks", () => {
			const mockCallback: ProductCallback = jest.fn();
			service.registerProductCallback(123456, mockCallback);

			const registeredIds = service.getRegisteredProductIds();
			expect(registeredIds.includes(123456)).toBe(true);
		});

		it("should unregister product callbacks", () => {
			const mockCallback: ProductCallback = jest.fn();
			service.registerProductCallback(123456, mockCallback);
			service.unregisterProductCallback(123456);

			const registeredIds = service.getRegisteredProductIds();
			expect(registeredIds.includes(123456)).toBe(false);
		});

		it("should return all registered product IDs", () => {
			const mockCallback1: ProductCallback = jest.fn();
			const mockCallback2: ProductCallback = jest.fn();

			service.registerProductCallback(123456, mockCallback1);
			service.registerProductCallback(789012, mockCallback2);

			const registeredIds = service.getRegisteredProductIds();
			expect(registeredIds.includes(123456)).toBe(true);
			expect(registeredIds.includes(789012)).toBe(true);
			expect(registeredIds.size()).toBe(2);
		});
	});

	describe("Example Product Registration", () => {
		it("should register example products without errors", () => {
			service.registerExampleProducts();

			const registeredIds = service.getRegisteredProductIds();
			expect(registeredIds.includes(123456)).toBe(true);
			expect(registeredIds.includes(123457)).toBe(true);
		});
	});

	describe("Service Properties", () => {
		it("should have correct version", () => {
			expect(service.version).toEqual({ major: 1, minor: 0, patch: 0 });
		});
	});
});
