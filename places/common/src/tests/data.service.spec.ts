// Test suite for DataService
import { DataService } from "server/services/data.service"; // Using server alias
import { mock, mockDeep, MockProxy } from "jest-mock-extended";
import { Players, RunService } from "@rbxts/services";
import ProfileStore from "@rbxts/profile-store";

// Mock dependencies
jest.mock("@rbxts/services", () => ({
    Players: mock<Players>(),
    RunService: mock<RunService>(),
}));

jest.mock("@rbxts/profile-store");

describe("DataService", () => {
    let dataService: DataService;
    let mockPlayers: MockProxy<Players>;
    let mockRunService: MockProxy<RunService>;
    let mockProfileStore: MockProxy<ReturnType<typeof ProfileStore.New>>;

    beforeEach(() => {
        // Reset mocks before each test
        mockPlayers = Players as unknown as MockProxy<Players>;
        mockRunService = RunService as unknown as MockProxy<RunService>;
        mockProfileStore = (ProfileStore.New as jest.Mock)(expect.anything(), expect.anything()) as unknown as MockProxy<ReturnType<typeof ProfileStore.New>>;

        // Mock RunService.IsStudio() behavior
        mockRunService.IsStudio.mockReturnValue(false); // Default to non-Studio environment

        dataService = new DataService();
    });

    it("should be defined", () => {
        expect(dataService).toBeDefined();
    });

    describe("onInit", () => {
        it("should initialize migrations", () => {
            // Spy on migrations.registerMigration
            const migrations = require("shared/utils/migrations").migrations; // Use shared alias
            const registerMigrationSpy = jest.spyOn(migrations, "registerMigration");

            dataService.onInit();

            // Expect registerMigration to have been called at least once
            expect(registerMigrationSpy).toHaveBeenCalled();

            // Example: Check if a specific migration is registered
            // This depends on the actual migration logic in DataService
            expect(registerMigrationSpy).toHaveBeenCalledWith(
                1,
                expect.any(Function),
                "Add missing SlotsApplicable field"
            );

            // Restore the spy
            registerMigrationSpy.mockRestore();
        });
    });

    // TODO: Add more tests here

    describe("dataCheck", () => {
        let migrateDataSpy: jest.SpyInstance;
        const MIGRATIONS_CURRENT_VERSION = require("shared/utils/migrations").migrations.CurrentVersion;

        beforeEach(() => {
            const migrationsUtil = require("shared/utils/migrations").migrations;
            migrateDataSpy = jest.spyOn(migrationsUtil, "migrateData")
                .mockImplementation((data: Record<string, unknown>, currentVersionNumber: number) => {
                    // Simplified mock: assume it migrates to MIGRATIONS_CURRENT_VERSION
                    // and applies known changes like SlotsApplicable if going from v1.
                    const migratedData = { ...data };
                    if (currentVersionNumber === 1 && MIGRATIONS_CURRENT_VERSION >= 2) {
                        // @ts-ignore
                        migratedData.SlotsApplicable = 3;
                    }
                    // Ensure _version is updated on the data object itself
                    // @ts-ignore
                    migratedData._version = MIGRATIONS_CURRENT_VERSION;
                    return [migratedData, MIGRATIONS_CURRENT_VERSION];
                });
        });

        afterEach(() => {
            migrateDataSpy.mockRestore();
        });

        it("should return default template for new data, migrated to current version", () => {
            const newData = {};
            // Data check always migrates to current version if _version is missing or old
            const expectedData = {
                ...dataService.template,
                _version: require("shared/utils/migrations").migrations.CurrentVersion
            };
            // Account for migration from v1 (default template version) to current if applicable
            // For example, if migration 1->2 adds SlotsApplicable, it should be present.
            // This depends on what migrations run from version 1 of the template.
            // Let's assume migration from v1 adds SlotsApplicable = 3 (as per DataService)
            if (require("shared/utils/migrations").migrations.CurrentVersion >= 2 && dataService.template._version <= 1) {
                 // @ts-ignore // Allow adding property for test
                expectedData.SlotsApplicable = 3;
            }
            // Add other expected fields from migrations if template starts at v1 and current is higher

            const result = dataService.dataCheck(newData);
    expect(result).toEqual(expectedData); // Full check restored
        });

        it("should migrate old data and merge with template", () => {
            const oldData = { _version: 1, oldField: "oldValue" };
            // Assuming migration from version 1 adds SlotsApplicable = 3
            const expectedData = {
                ...dataService.template,
                _version: require("shared/utils/migrations").migrations.CurrentVersion, // Use shared alias
                SlotsApplicable: 3, // From migration 1 -> 2
                oldField: "oldValue", // Extra fields should be preserved
            };
            const result = dataService.dataCheck(oldData);
            expect(result).toEqual(expectedData);
        });

        it("should handle data with extra fields not in template, and migrate if version is old", () => {
            // Template version is 1. Current version is 6.
            const dataWithExtra = { ...dataService.template, _version: 1, extraField: "extraValue" };
            const expectedData = {
                ...dataService.template,
                _version: require("shared/utils/migrations").migrations.CurrentVersion,
                SlotsApplicable: 3, // From migration 1 -> 2
                extraField: "extraValue",
            };
            const result = dataService.dataCheck(dataWithExtra);
            expect(result).toEqual(expectedData);
        });

        it("should call migrations.migrateData if version is older", () => {
            // Relies on migrateDataSpy from the describe block's beforeEach
            const oldData = { _version: 1 };
            dataService.dataCheck(oldData);
            // The spy is already set up by beforeEach.
            // The mockImplementation in beforeEach might not be what we want to test here,
            // as we are testing IF it's called, not its mocked return.
            // However, for this specific test, we just care it was called with correct args.
            // The object passed is mutated by dataCheck, so we check the state AT THE TIME OF CALL.
            // The first argument to the spy should be the dataTable as it was when migrateData was called.
            expect(migrateDataSpy).toHaveBeenCalledWith(
                expect.objectContaining({ _version: 1 }), // At the time of call, dataTable._version is 1
                1
            );
            // No need to restore here, afterEach will handle it.
        });
    });

    describe("Profile Operations", () => {
        let mockPlayer: MockProxy<Player>;
        let mockProfile: MockProxy<NonNullable<ReturnType<ReturnType<typeof ProfileStore.New>["StartSessionAsync"]>>>;

        beforeEach(() => {
            mockPlayer = mock<Player>();
            mockPlayer.UserId = 123; // Example UserId
            mockPlayer.DisplayName = "TestPlayer";
            mockPlayer.Parent = mockPlayers; // Mock Player.Parent

            mockProfile = mockDeep<NonNullable<ReturnType<ReturnType<typeof ProfileStore.New>["StartSessionAsync"]>>>();
            mockProfile.Data = { ...dataService.template }; // Default data
            mockProfile.OnSessionEnd = { Connect: jest.fn() } as any;


            // Mock ProfileStore.StartSessionAsync to return the mockProfile
            (mockProfileStore.StartSessionAsync as jest.Mock).mockResolvedValue(mockProfile);
        });

        describe("openDocument", () => {
            it("should open a profile and store it", async () => {
                const success = await dataService.openDocument(mockPlayer);
                expect(success).toBe(true);
                expect(mockProfileStore.StartSessionAsync).toHaveBeenCalledWith(
                    `Player_${mockPlayer.UserId}`,
                    expect.any(Object)
                );
                expect(mockProfile.AddUserId).toHaveBeenCalledWith(mockPlayer.UserId);
                // Check if profile is stored (internal state, might need adjustment)
                // expect(dataService.profiles.get(mockPlayer)).toBe(mockProfile);
            });

            it("should return false if player leaves before profile loads", async () => {
                mockPlayer.Parent = undefined; // Simulate player leaving
                const success = await dataService.openDocument(mockPlayer);
                expect(success).toBe(false);
                expect(mockProfile.EndSession).toHaveBeenCalled();
            });
        });

        describe("getCache", () => {
            it("should open document if profile not loaded and return data", async () => {
                const data = await dataService.getCache(mockPlayer);
                expect(mockProfileStore.StartSessionAsync).toHaveBeenCalled();
                expect(data).toEqual(dataService.dataCheck({ ...dataService.template }));
            });

            it("should return existing profile data if already loaded", async () => {
                // Pre-load profile
                await dataService.openDocument(mockPlayer);
                (mockProfileStore.StartSessionAsync as jest.Mock).mockClear(); // Clear previous calls

                const data = await dataService.getCache(mockPlayer);
                expect(mockProfileStore.StartSessionAsync).not.toHaveBeenCalled();
                expect(data).toEqual(dataService.dataCheck({ ...dataService.template }));
            });
        });

        describe("closeDocument", () => {
            it("should end session if profile exists", async () => {
                await dataService.openDocument(mockPlayer); // Ensure profile is loaded
                dataService.closeDocument(mockPlayer);
                expect(mockProfile.EndSession).toHaveBeenCalled();
            });

            it("should not throw if profile does not exist", () => {
                expect(() => dataService.closeDocument(mockPlayer)).not.toThrow();
            });
        });
    });

    describe("setCache", () => {
        let mockPlayer: MockProxy<Player>;
        let mockProfile: MockProxy<NonNullable<ReturnType<ReturnType<typeof ProfileStore.New>["StartSessionAsync"]>>>;

        beforeEach(async () => { // Made async to await openDocument
            mockPlayer = mock<Player>();
            mockPlayer.UserId = 456;
            mockPlayer.DisplayName = "CacheSetter";
            mockPlayer.Parent = mockPlayers;

            mockProfile = mockDeep<NonNullable<ReturnType<ReturnType<typeof ProfileStore.New>["StartSessionAsync"]>>>();
            mockProfile.Data = { ...dataService.template };
            mockProfile.OnSessionEnd = { Connect: jest.fn() } as any;

            (mockProfileStore.StartSessionAsync as jest.Mock).mockResolvedValue(mockProfile);
            // Ensure profile is loaded before setCache is called
            await dataService.openDocument(mockPlayer);
        });

        it("should set validated and optimized data to the profile", () => {
            const newCache = {
                ...dataService.template,
                PlayerStatistics: {
                    ...dataService.template.PlayerStatistics,
                    Jumps: 100, // Changed value
                },
                AnotherField: "newValue", // New field
            };

            dataService.setCache(mockPlayer, newCache);

            // Expect dataCheck to have been called (implicitly tested by checking optimizedData)
            // Expect data to be optimized (default values removed, _version kept)
            const expectedOptimizedData = {
                _version: newCache._version, // Assuming _version is part of template or added by dataCheck
                PlayerStatistics: {
                    Jumps: 100,
                },
                AnotherField: "newValue",
            };

            // Need to access the internal profiles map for this check or spy on profile.Data assignment
            // For simplicity, let's assume profile.Data was set correctly
            // A more robust test would spy on `mockProfile.Data = ...`
            // or retrieve the profile again and check its Data.
            // However, direct assignment like `profile.Data = optimizedData` is hard to spy on directly with jest-mock-extended for properties.
            // A workaround would be to make `profiles` map protected and access it in tests, or add a getter for testing.

            // For now, we'll check the structure of what *should* be set.
            // This relies on the internal logic of setCache.
            const setData = mockProfile.Data; // This will be the data from beforeEach, not what was set
                                          // This highlights a limitation in directly testing the assignment without spies or getters.

            // To properly test this, we'd ideally spy on the assignment to `profile.Data`.
            // Let's assume `dataCheck` and optimization logic are correct as tested elsewhere/implicitly.
            // The main thing to check here is that `profile.Data` is updated.
            // We can capture the argument passed to `profile.Data = ...` if we could spy on it.

            // Since direct property assignment spying is tricky, we'll trust the internal logic
            // and assume that if dataCheck is called, the optimization and assignment follow.
            // A more integration-style test would be needed to fully verify the Data property update.

            // We can at least check that dataCheck was implicitly part of the flow by its effect.
            // If `dataCheck` wasn't called, `_version` might be missing or wrong.
            // If optimization didn't happen, default values would persist.

            // Let's spy on dataCheck to ensure it's part of the process
            const dataCheckSpy = jest.spyOn(dataService, "dataCheck");
            dataService.setCache(mockPlayer, { ...newCache }); // Re-call with a fresh object
            expect(dataCheckSpy).toHaveBeenCalledWith(expect.objectContaining({ AnotherField: "newValue" }));
            dataCheckSpy.mockRestore();

            // And verify the profile data was indeed updated
            // This requires the mockProfile.Data to be updated by the setCache method.
            // The `mockProfile.Data = optimizedData as DataTemplate;` line in `setCache` should do this.
            expect(mockProfile.Data.PlayerStatistics.Jumps).toBe(100);
            expect((mockProfile.Data as any).AnotherField).toBe("newValue");
             // Check if default values are stripped (e.g. if a value was same as template, it should be gone)
            // Example: if 'Kills' was default and not in newCache, it shouldn't be in optimized data unless it's in template
            // This part is harder to verify without knowing exact template defaults vs newCache.
        });

        it("should throw an error if profile is not found", () => {
            const nonExistentPlayer = mock<Player>();
            nonExistentPlayer.UserId = 789;
            expect(() => dataService.setCache(nonExistentPlayer, dataService.template)).toThrow("Profile not found for player");
        });
    });

    describe("Performance Methods", () => {
        const performance = require("shared/utils/performance").performance; // Use shared alias
        let getMetricsSpy: jest.SpyInstance;
        let printReportSpy: jest.SpyInstance;

        beforeEach(() => {
            getMetricsSpy = jest.spyOn(performance, "getMetrics");
            printReportSpy = jest.spyOn(performance, "printReport");
        });

        afterEach(() => {
            getMetricsSpy.mockRestore();
            printReportSpy.mockRestore();
        });

        describe("getPerformanceMetrics", () => {
            it("should call performance.getMetrics and return its result", () => {
                const mockMetrics = { totalTime: 100, operations: 5 };
                getMetricsSpy.mockReturnValue(mockMetrics);

                const result = dataService.getPerformanceMetrics();
                expect(getMetricsSpy).toHaveBeenCalledTimes(1);
                expect(result).toEqual(mockMetrics);
            });
        });

        describe("printPerformanceReport", () => {
            it("should call performance.printReport", () => {
                dataService.printPerformanceReport();
                expect(printReportSpy).toHaveBeenCalledTimes(1);
            });
        });
    });
});
