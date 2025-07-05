// Types
export type * as Chances from "./chances";
export type * as Evolve from "./evolve";

import type SharedChances from "./chances";
import type SharedEvolve from "./evolve";

export default interface SharedType {
	chances: SharedChances;
	evolve: SharedEvolve;
}
