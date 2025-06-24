import { PassiveData } from "../passive";

export const RoyalFamily: PassiveData = {
    name: "Royal Family",
    description: "This unit gets +100% more yen from enemies and bosses",
    callbacks: {
        // This passive affects game economy (yen earned).
        // No direct combat callbacks in Luau.
        // Implementation would likely involve:
        // 1. Tagging the unit with this passive (e.g., "RoyalFamilyYenBonus").
        // 2. The game's yen awarding system checks if the unit credited with a kill
        //    (or participating units, depending on rules) has this tag.
        // 3. If tagged, the yen amount is doubled.
        // Example (conceptual, not a direct callback):
        // getModifiedYenAward: (unit: Unit, baseYen: number) => {
        //     if (unit.hasPassive("RoyalFamily")) { // or unit.hasTag("RoyalFamilyYenBonus")
        //         return baseYen * 2; // +100% more
        //     }
        //     return baseYen;
        // }
    },
};
