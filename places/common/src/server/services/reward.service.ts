import { Service } from "@flamework/core";
import { PlayerData } from "shared/atoms/player-data";
import { HttpService } from "@rbxts/services";

@Service({})
export class RewardService {
	public giveReward(playerData: PlayerData, reward: { type: string; name: string; amount: number }): void {
		switch (reward.type) {
			case "currency":
				this.giveCurrency(playerData, reward.name, reward.amount);
				break;
			case "item":
				this.giveItem(playerData, reward.name, reward.amount);
				break;
			default:
				warn(`Unknown reward type: ${reward.type}`);
		}
	}

	private giveCurrency(playerData: PlayerData, currencyName: string, amount: number): void {
		const currency = currencyName as keyof typeof playerData.currencies;
		if (playerData.currencies[currency]) {
			playerData.currencies[currency] += amount;
		} else {
			warn(`Unknown currency: ${currencyName}`);
		}
	}

	private giveItem(playerData: PlayerData, itemName: string, amount: number): void {
		const item = playerData.items.find((i) => i.id === itemName);
		if (item) {
			item.amount += amount;
		} else {
			playerData.items.push({
				id: itemName,
				uuid: HttpService.GenerateGUID(false),
				amount: amount,
				locked: false,
			});
		}
	}
}
