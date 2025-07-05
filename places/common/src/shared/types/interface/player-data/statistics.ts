// Types
import type { Source } from "@rbxts/vide";

export default interface PlayerDataStatistics {
	["Total Damage"]: Source<number>;
	["Total Summons"]: Source<number>;
	["Play Time"]: Source<number>;

	["Summoned Secrets"]: Source<number>;
	["Summoned Mythicals"]: Source<number>;
	["Summoned Shinies"]: Source<number>;

	["Kills"]: Source<number>;
	["Games Played"]: Source<number>;
}
