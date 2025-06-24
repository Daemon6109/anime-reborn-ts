import { PassiveData } from "../passive";

export const PerfectScar: PassiveData = {
    name: "Perfect Scar",
    description: "This unit applies 'Scar' on all attacks that deals 15% of unit damage per tick, double of normal scar",
    callbacks: {}, // The core logic is that this unit's "Scar" application is special.
                   // This would likely be handled by:
                   // 1. This passive granting the unit a specific tag, e.g., "AppliesPerfectScar".
                   // 2. The status effect system, when applying "Scar" from a unit with this tag,
                   //    uses a different configuration for the Scar DoT (15% damage per tick, potentially different duration/ticks).
                   // The description "double of normal scar" implies a comparison point which needs to be defined.
};
