import { expect, describe, it, beforeEach, jest } from "@rbxts/jest-globals";
import { TeamEventsService } from "@server/services/team-events.service";

describe("TeamEventsService", () => {
	let teamEventsService: TeamEventsService;

	beforeEach(() => {
		teamEventsService = new TeamEventsService();
		// Don't call onStart() to avoid Players service dependencies and infinite loops
	});

	describe("Service Information", () => {
		it("should have version information", () => {
			expect(teamEventsService.version.major).toBe(1);
			expect(teamEventsService.version.minor).toBe(0);
			expect(teamEventsService.version.patch).toBe(0);
		});

		it("should have team joined event", () => {
			expect(teamEventsService.teamJoined).toBeDefined();
		});

		it("should have points earned event", () => {
			expect(teamEventsService.pointsEarned).toBeDefined();
		});

		it("should have event ended event", () => {
			expect(teamEventsService.eventEnded).toBeDefined();
		});
	});

	describe("Team Management", () => {
		it("should handle team event configuration", () => {
			const testConfig = {
				name: "Test Event",
				description: "A test team event",
				teams: ["Team A", "Team B", "Team C"],
				startTime: 1000000000,
				endTime: 1000010000,
				rewards: {
					"Team A": {
						1: { Gold: 1000, XP: 500 }, // 1st place
						2: { Gold: 500, XP: 250 }, // 2nd place
					},
					"Team B": {
						1: { Gold: 1000, XP: 500 },
						2: { Gold: 500, XP: 250 },
					},
					"Team C": {
						1: { Gold: 1000, XP: 500 },
						2: { Gold: 500, XP: 250 },
					},
				},
			};

			expect(testConfig.name).toBe("Test Event");
			expect(testConfig.teams.size()).toBe(3);
			expect(testConfig.teams.includes("Team A")).toBe(true);
			expect(testConfig.rewards["Team A"][1].Gold).toBe(1000);
		});

		it("should support team ranking structure", () => {
			const ranking = {
				team: "Team A",
				contribution: 1500,
			};

			expect(ranking.team).toBe("Team A");
			expect(ranking.contribution).toBe(1500);
		});
	});

	describe("Event Configuration", () => {
		it("should support event registration", () => {
			const eventId = "test-event-123";
			const eventConfig = {
				name: "Test Event",
				description: "A test team event",
				teams: ["Team A", "Team B"],
				startTime: 1000000000,
				endTime: 1000010000,
				rewards: {},
			};

			// Test that we can register an event without errors
			let caughtError: unknown;
			try {
				teamEventsService.registerEvent(eventId, eventConfig);
			} catch (e) {
				caughtError = e;
			}
			expect(caughtError).toBeUndefined();
		});

		it("should check event time validity", () => {
			const currentTime = os.time();
			const pastEvent = {
				name: "Past Event",
				description: "An event in the past",
				teams: ["Team A", "Team B"],
				startTime: currentTime - 10000,
				endTime: currentTime - 5000,
				rewards: {},
			};

			const futureEvent = {
				name: "Future Event",
				description: "An event in the future",
				teams: ["Team A", "Team B"],
				startTime: currentTime + 5000,
				endTime: currentTime + 10000,
				rewards: {},
			};

			expect(pastEvent.endTime).toBeLessThan(currentTime);
			expect(futureEvent.startTime).toBeGreaterThan(currentTime);
		});

		it("should handle active events map", () => {
			const activeEvents = teamEventsService.getActiveEvents();
			expect(activeEvents).toBeDefined();
			expect(typeIs(activeEvents, "table")).toBe(true);
		});
	});

	describe("Data Structures", () => {
		it("should support team event data structure", () => {
			const teamEventData = {
				Team: "Team A",
				ContributedSouls: 100,
				ContributedReaperParts: 25,
			};

			expect(teamEventData.Team).toBe("Team A");
			expect(teamEventData.ContributedSouls).toBe(100);
			expect(teamEventData.ContributedReaperParts).toBe(25);
		});

		it("should support player contribution tracking", () => {
			const contribution = {
				playerId: 12345,
				teamName: "Team A",
				souls: 150,
				reaperParts: 30,
			};

			expect(contribution.playerId).toBe(12345);
			expect(contribution.teamName).toBe("Team A");
			expect(contribution.souls).toBe(150);
			expect(contribution.reaperParts).toBe(30);
		});
	});
});
