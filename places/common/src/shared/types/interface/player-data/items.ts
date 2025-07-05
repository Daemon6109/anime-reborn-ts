// Types
import * as Types from "@shared/types";

export interface Constant {
	name: string;
	displayName: string;
	description: string;
	category: Types.Categories.Item;
	rarity: Types.Rarities.default;
}

export interface Preview {
	name: string;
	displayName: string;
	description: string;
	category: Types.Categories.Item;
	rarity: Types.Rarities.default;

	amount?:
		| {
				min: number;
				max: number;
		  }
		| number;
}

export interface Player {
	id: string;
	uuid: string;
	amount: number;
	locked: boolean;
}

type ItemData = Constant & Player;
export default ItemData;
