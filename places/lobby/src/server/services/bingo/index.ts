import { Service, OnStart, OnInit } from "@flamework/core";
import { Players } from "@rbxts/services";
import { DataStore } from "@common/server/services/player-data";
import { Analytics } from "@common/server/services/analytics";
import { safePlayerAdded } from "@common/shared/utils/safe-player-added.util";
import { Janitor } from "@rbxts/janitor";
import { BingoData, BingoQuest } from "./types";
import { PlayerData } from "@common/shared/atoms/player-data";
import {
	BINGO_BOARD_SIZE,
	BINGO_QUESTS,
	BINGO_ROW_REWARDS,
	BINGO_COLUMN_REWARDS,
	BINGO_DIAGONAL_REWARDS,
} from "./constants";
import { RewardService } from "@common/server/services/reward.service";

@Service({})
export class BingoService implements OnInit, OnStart {
	private readonly janitor = new Janitor<{
		PlayerConnections: Map<Player, RBXScriptConnection>;
	}>();

	constructor(
		private readonly dataStore: DataStore,
		private readonly analytics: Analytics,
		private readonly rewardService: RewardService,
	) {}

	onInit(): void {
		// Not used
	}

	onStart(): void {
		const playerConnections = new Map<Player, RBXScriptConnection>();
		this.janitor.Add(playerConnections, "clear", "PlayerConnections");

		const playerAddedConnection = safePlayerAdded((player: Player) => {
			this.handlePlayerJoined(player);
		});
		this.janitor.Add(playerAddedConnection, "Disconnect");

		const playerRemovingConnection = Players.PlayerRemoving.Connect((player: Player) => {
			this.handlePlayerLeaving(player, playerConnections);
		});
		this.janitor.Add(playerRemovingConnection, "Disconnect");
	}

	private async handlePlayerJoined(player: Player): Promise<void> {
		const bingoData = await this.getBingoData(player);
		if (!bingoData) {
			this.refreshBoard(player);
		}
	}

	private handlePlayerLeaving(player: Player, connections: Map<Player, RBXScriptConnection>): void {
		const connection = connections.get(player);
		if (connection) {
			connection.Disconnect();
			connections.delete(player);
		}
	}

	public async getBingoData(player: Player): Promise<BingoData | undefined> {
		const store = this.dataStore.getPlayerStore();
		const data = await store.get(player);
		return data.bingo;
	}

	public async claimRowReward(player: Player, row: number): Promise<void> {
		const store = this.dataStore.getPlayerStore();
		const bingoData = await this.getBingoData(player);

		if (!bingoData) {
			return;
		}

		if (bingoData.rowRewards[row]) {
			return; // Already claimed
		}

		const isRowComplete = bingoData.board[row].every((quest) => quest.completed);
		if (!isRowComplete) {
			return;
		}

		const reward = BINGO_ROW_REWARDS[row];
		if (!reward) {
			return;
		}

		await store.update(player, (oldData) => {
			if (oldData.bingo) {
				oldData.bingo.rowRewards[row] = true;
				this.rewardService.giveReward(oldData, reward);
			}
			return true;
		});
	}

	public async claimColumnReward(player: Player, column: number): Promise<void> {
		const store = this.dataStore.getPlayerStore();
		const bingoData = await this.getBingoData(player);

		if (!bingoData) {
			return;
		}

		if (bingoData.columnRewards[column]) {
			return; // Already claimed
		}

		const isColumnComplete = bingoData.board.every((row) => row[column].completed);
		if (!isColumnComplete) {
			return;
		}

		const reward = BINGO_COLUMN_REWARDS[column];
		if (!reward) {
			return;
		}

		await store.update(player, (oldData) => {
			if (oldData.bingo) {
				oldData.bingo.columnRewards[column] = true;
				this.rewardService.giveReward(oldData, reward);
			}
			return true;
		});
	}

	public async claimDiagonalReward(player: Player, diagonal: number): Promise<void> {
		const store = this.dataStore.getPlayerStore();
		const bingoData = await this.getBingoData(player);

		if (!bingoData) {
			return;
		}

		if (bingoData.diagonalRewards[diagonal]) {
			return; // Already claimed
		}

		let isDiagonalComplete = true;
		if (diagonal === 0) {
			for (let i = 0; i < BINGO_BOARD_SIZE; i++) {
				if (!bingoData.board[i][i].completed) {
					isDiagonalComplete = false;
					break;
				}
			}
		} else {
			for (let i = 0; i < BINGO_BOARD_SIZE; i++) {
				if (!bingoData.board[i][BINGO_BOARD_SIZE - 1 - i].completed) {
					isDiagonalComplete = false;
					break;
				}
			}
		}

		if (!isDiagonalComplete) {
			return;
		}

		const reward = BINGO_DIAGONAL_REWARDS[diagonal];
		if (!reward) {
			return;
		}

		await store.update(player, (oldData) => {
			if (oldData.bingo) {
				oldData.bingo.diagonalRewards[diagonal] = true;
				this.rewardService.giveReward(oldData, reward);
			}
			return true;
		});
	}

	public async refreshBoard(player: Player): Promise<void> {
		const store = this.dataStore.getPlayerStore();
		const newBoard: BingoQuest[][] = [];
		const usedQuests = new Set<string>();

		for (let i = 0; i < BINGO_BOARD_SIZE; i++) {
			newBoard[i] = [];
			for (let j = 0; j < BINGO_BOARD_SIZE; j++) {
				let randomQuest = BINGO_QUESTS[math.floor(math.random() * BINGO_QUESTS.size())];
				while (usedQuests.has(randomQuest)) {
					randomQuest = BINGO_QUESTS[math.floor(math.random() * BINGO_QUESTS.size())];
				}
				usedQuests.add(randomQuest);

				newBoard[i][j] = {
					id: randomQuest,
					completed: false,
					progress: 0,
					target: 1,
				};
			}
		}

		const rowRewards: boolean[] = [];
		for (let i = 0; i < BINGO_BOARD_SIZE; i++) {
			rowRewards.push(false);
		}

		const columnRewards: boolean[] = [];
		for (let i = 0; i < BINGO_BOARD_SIZE; i++) {
			columnRewards.push(false);
		}

		const diagonalRewards: boolean[] = [];
		for (let i = 0; i < 2; i++) {
			diagonalRewards.push(false);
		}

		const newBingoData: BingoData = {
			board: newBoard,
			lastRefreshed: os.time(),
			rowRewards: rowRewards,
			columnRewards: columnRewards,
			diagonalRewards: diagonalRewards,
		};

		await store.update(player, (oldData) => {
			oldData.bingo = newBingoData;
			return true;
		});
	}

	public destroy(): void {
		this.janitor.Cleanup();
	}
}
