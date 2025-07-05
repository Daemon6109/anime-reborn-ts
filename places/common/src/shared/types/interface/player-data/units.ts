// Types
import type { Preview as ItemPreview } from "./items";
import * as Categories from "@shared/types/categories";
import * as UnitTypes from "@shared/types/unit";
import Rarities from "@shared/types/rarities";
import Traits from "@shared/types/traits";

export interface Player {
	id: string;
	uuid: string;
	obtainedAt: number;
	trait?: Traits;

	traitData?: {
		trait: Traits;
		time: number;
	}[];

	evo: number;
	shiny: boolean;
	locked: boolean;
	favorited: boolean;
	level: {
		value: number;
		target: number;
		current: number;
	};
	potential: {
		damage: number;
		range: number;
		spa: number;
	};
}

export interface Constant {
	name: string;
	displayName: string;
	rarity: Rarities;
	category: Categories.Unit;
	released: boolean;
	tradable: boolean;
	sellable: boolean;
	placement: number;
	radius: number;

	element: UnitTypes.Elements;
	type: UnitTypes.UnitTypes;

	price: number;
	damage?: number;
	money?: number;
	range: number;
	spa: number;
	attackSize: number;
	attackEffects?: string[];
	attackType: UnitTypes.AttackTypes;

	passive: string[];

	animations: {
		idle: number;
		walk: number;
	};

	upgrades: Array<{
		price: number;
		damage?: number;
		money?: number;
		range?: number;
		attackSpeed?: number;
		unitType?: UnitTypes.UnitTypes;
		newAbility?: {
			name: string;
			attackSize: number;
			attackEffects?: string[];
			attackType: UnitTypes.AttackTypes;
		};
	}>;

	evoData?: {
		unit: Constant;
		display: string[];
		requirements: Array<Constant | ItemPreview>;
	};

	criticalData: {
		chance: number;
		multiplier: number;
	};
}

type UnitData = Constant & Player;
export default UnitData;
