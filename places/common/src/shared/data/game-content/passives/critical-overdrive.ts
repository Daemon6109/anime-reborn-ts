import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const CriticalOverdrive: PassiveData = {
    name: "Critical Overdrive",
    description: "50% Crit Chance + 75% Crit Damage",
    callbacks: {
        onPlace: (unit: Unit) => {
            // TODO: Implement attribute setting for both PermanentAttackCriticalChance and PermanentAttackCriticalDamage
            // The Luau code only sets PermanentAttackCriticalDamage to 1.75.
            // This implies base crit damage is 1 (or 100%), and this adds 0.75, making it 1.75x.
            // Or it means the final crit damage is 1.75x.
            // It does NOT set crit chance in the Luau onPlace. This might be handled by unit's base stats or another system.
            // For now, mirroring Luau:
            // unit.setAttribute("PermanentAttackCriticalDamage", 1.75);
            // unit.setAttribute("PermanentAttackCriticalChance", (unit.getAttribute("PermanentAttackCriticalChance") || 0) + 0.50); // Assuming this should also be set
        },
    },
};
