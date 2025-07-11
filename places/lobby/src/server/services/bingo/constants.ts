export const BINGO_BOARD_SIZE = 5;

export const BINGO_QUESTS = [
	"Defeat 100 enemies",
	"Collect 1000 gold",
	"Open 10 chests",
	"Complete 5 quests",
	"Evolve a unit",
	"Craft an item",
	"Defeat a boss",
	"Win a duel",
	"Reach wave 10 in a dungeon",
	"Complete a raid",
	"Buy an item from the shop",
	"Sell an item",
	"Upgrade a unit's level",
	"Unlock a new area",
	"Find a secret",
	"Join a team",
	"Send a message in chat",
	"Use an emote",
	"Jump 100 times",
	"Walk 1000 studs",
	"Play for 1 hour",
	"Defeat 5 different types of enemies",
	"Collect 5 different types of items",
	"Use 3 different skills",
	"Complete a daily quest",
];

export const BINGO_ROW_REWARDS = [
	{ type: "currency", name: "gold", amount: 1000 },
	{ type: "currency", name: "gems", amount: 100 },
	{ type: "item", name: "common-chest", amount: 1 },
	{ type: "item", name: "rare-chest", amount: 1 },
	{ type: "item", name: "epic-chest", amount: 1 },
];

export const BINGO_COLUMN_REWARDS = [
	{ type: "currency", name: "gold", amount: 1000 },
	{ type: "currency", name: "gems", amount: 100 },
	{ type: "item", name: "common-chest", amount: 1 },
	{ type: "item", name: "rare-chest", amount: 1 },
	{ type: "item", name: "epic-chest", amount: 1 },
];

export const BINGO_DIAGONAL_REWARDS = [
	{ type: "item", name: "legendary-chest", amount: 1 },
	{ type: "item", name: "mythic-chest", amount: 1 },
];
