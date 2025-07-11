import { Service, OnStart } from "@flamework/core";
import { DataStoreService } from "@rbxts/services";
import ServerNetwork from "@network/server";

const DEFAULT_LIMIT = 10000;

@Service({})
export class GohanLimitService implements OnStart {
	private gohanLimitDataStore = DataStoreService.GetDataStore("GohanLimit");

	onStart(): void {
		this.updateData();
		task.spawn(() => {
			while (task.wait(60)) {
				this.updateData();
			}
		});

		ServerNetwork.GohanLimit.GetGohanLimitData.on((player) => {
			const limit = this.gohanLimitDataStore.GetAsync("Limit")[0] as number ?? DEFAULT_LIMIT;
			const obtained = this.gohanLimitDataStore.GetAsync("Obtained")[0] as number ?? 0;
			return $tuple(limit, obtained);
		});
	}

	private async updateData(): Promise<void> {
		let [limit] = await this.gohanLimitDataStore.GetAsync("Limit");
		let [obtained] = await this.gohanLimitDataStore.GetAsync("Obtained");

		if (!limit) {
			await this.gohanLimitDataStore.SetAsync("Limit", DEFAULT_LIMIT);
			limit = DEFAULT_LIMIT;
		}

		if (!obtained) {
			await this.gohanLimitDataStore.SetAsync("Obtained", 0);
			obtained = 0;
		}

		ServerNetwork.GohanLimit.UpdateGohanLimit.fireAll(limit as number, obtained as number);
	}

	public async getLimit(): Promise<number> {
		const [limit] = await this.gohanLimitDataStore.GetAsync("Limit");
		return limit as number;
	}

	public async getObtainedAmount(): Promise<number> {
		const [obtained] = await this.gohanLimitDataStore.GetAsync("Obtained");
		return obtained as number;
	}

	public async incrementObtainedAmount(): Promise<void> {
		await this.gohanLimitDataStore.IncrementAsync("Obtained", 1);
	}
}
