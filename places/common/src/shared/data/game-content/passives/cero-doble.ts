import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const CeroDoble: PassiveData = {
    name: "Cero Doble",
    description: "Every 5 hits, her next attack will have 100% crit chance + 100% crit damage, She also has stun immunity on placement.",
    callbacks: {
        onPlace: (unit: Unit) => {
            unit.addTag("InnateNonTarget");
            unit.addTag("InnateNoStun");
        },
        onAttack: (unit: Unit) => {
            // TODO: Implement attribute getting/setting
            // let ceroDobleStacks = unit.getAttribute("CeroDobleStacks") || 0;
            // if (!unit.getAttribute("CeroDobleBuff")) { // Only increment if buff is not already active
            //     ceroDobleStacks++;
            //     unit.setAttribute("CeroDobleStacks", ceroDobleStacks);
            //     if (ceroDobleStacks >= 5) {
            //         unit.setAttribute("CeroDobleBuff", true);
            //         unit.setAttribute("CeroDobleStacks", 0); // Reset stacks after activating buff
            //     }
            // }
        },
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement attribute getting. Return type needs to accommodate crit chance and crit damage.
            // if (enemy && enemy.Health > 0 && unit.getAttribute("CeroDobleBuff")) {
            //     // Luau returns: damageMultiplier, isCrit (true/false), critDamageMultiplier
            //     // This needs to be represented appropriately in TS, e.g., an object or a specific tuple type.
            //     // For now, returning a simple multiplier, but this is incomplete.
            //     return { damageMultiplier: 1, isCrit: true, critDamageMultiplier: 1 }; // Example structure
            // }
            return 1; // Or { damageMultiplier: 1, isCrit: false, critDamageMultiplier: 0 }
        },
        onAttackEnded: (unit: Unit) => {
            // TODO: Implement attribute setting
            // // Consume the buff after the attack that benefits from it
            // if (unit.getAttribute("CeroDobleBuff")) {
            //     unit.setAttribute("CeroDobleBuff", undefined); // Or false
            // }
        },
    },
};
