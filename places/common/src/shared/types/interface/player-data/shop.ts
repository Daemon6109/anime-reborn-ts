// Types
import type { Source } from "@rbxts/vide";

export type LayoutOneRaw = {
	layout: 1;
	imageId: number;
	text: [string] | [string, string];
};

export type LayoutTwoRaw = {
	layout: 2;
	name: string;
	imageId: number;
	text:
		| [string]
		| [string, string]
		| [string, string, string]
		| [string, string, string, string]
		| [string, string, string, string, string];
};

export type LayoutThreeRaw = {
	layout: 3;
	name: string;
	imageIds: [number, number];
	text:
		| [string]
		| [string, string]
		| [string, string, string]
		| [string, string, string, string]
		| [string, string, string, string, string]
		| [string, string, string, string, string, string]
		| [string, string, string, string, string, string, string]
		| [string, string, string, string, string, string, string, string];
};

export type BaseRawProps = {
	cost: number;
	productId: number;
	color: ColorSequence;
};

export type ShopItemRawProps = BaseRawProps & (LayoutOneRaw | LayoutTwoRaw | LayoutThreeRaw);

export type LayoutOne = {
	layout: Source<1>;
	imageId: Source<number>;
	text: Source<[string] | [string, string]>;
};

export type LayoutTwo = {
	layout: Source<2>;
	name: Source<string>;
	imageId: Source<number>;
	text: Source<
		| [string]
		| [string, string]
		| [string, string, string]
		| [string, string, string, string]
		| [string, string, string, string, string]
	>;
};

export type LayoutThree = {
	layout: Source<3>;
	name: Source<string>;
	imageIds: Source<[number, number]>;
	text: Source<
		| [string]
		| [string, string]
		| [string, string, string]
		| [string, string, string, string]
		| [string, string, string, string, string]
		| [string, string, string, string, string, string]
		| [string, string, string, string, string, string, string]
		| [string, string, string, string, string, string, string, string]
	>;
};

export type BaseShopItem = {
	cost: Source<number>;
	productId: Source<string>;
	stock: Source<number>;
	color: Source<ColorSequence>;
};

export type ShopItem = BaseShopItem & (LayoutOne | LayoutTwo | LayoutThree);

export type ShopItems = Array<ShopItem>;

export default interface PlayerDataShop {
	bundles: Source<ShopItems>;
	passes: Source<ShopItems>;
	gems: Source<ShopItems>;
	traitCrystals: Source<ShopItems>;
	keys: Source<ShopItems>;
	stones: Source<ShopItems>;
	potions: Source<ShopItems>;
	gold: Source<ShopItems>;
}
