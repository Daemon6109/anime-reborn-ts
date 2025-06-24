import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const KanzenSaimin: PassiveData = {
    name: "Kanzen Saimin",
    description: "After 20 eliminations, his next attack will apply Dark Flames",
    // killsNeeded: 15, // Luau config uses 15, description says 20. Using Luau value.
    callbacks: {
        onKill: async (unit: Unit) => {
            // TODO: Implement attribute getting/setting, unit.waitForChild
            // const config = await unit.waitForChild("configuration", 10); // Placeholder for async
            // if (!config) return;

            // const isModeActive = unit.getAttribute("KanzenSaiminMode") || false;
            // if (isModeActive) return; // Don't stack kills if mode is already primed

            // let kills = unit.getAttribute("KanzenSaiminKills") || 0;
            // kills++;

            // if (kills >= KanzenSaimin.killsNeeded) {
            //     unit.setAttribute("KanzenSaiminKills", 0);
            //     unit.setAttribute("KanzenSaiminMode", true); // Prime the special attack
            // } else {
            //     unit.setAttribute("KanzenSaiminKills", kills);
            // }
        },
        onAttack: async (unit: Unit) => { // This happens before the attack hits or as it's being processed
            // TODO: Implement attribute getting/setting, unit.waitForChild, unit.configuration modification
            // const config = await unit.waitForChild("configuration", 10); // Placeholder
            // if (!config) return;

            // if (unit.getAttribute("KanzenSaiminMode") === true) {
            //     // Store original attack effect if not already stored for this primed attack
            //     if (unit.getAttribute("KanzenSaiminOldAttackEffectName") === undefined) { // Use more descriptive names
            //         // unit.setAttribute("KanzenSaiminOldAttackEffectName", config.AttackEffect.Value);
            //         // unit.setAttribute("KanzenSaiminOldAttackEffectDuration", config.AttackEffectDuration.Value);
            //     }
            //     // Temporarily change attack effect for this hit
            //     // config.AttackEffect.Value = "Dark Flames";
            //     // config.AttackEffectDuration.Value = 5; // Duration for Dark Flames
            //     // This modification of config at runtime needs a robust system in TS.
            //     // Alternative: set temporary attributes that the attack system reads.
            //     // unit.setAttribute("OverrideAttackEffectName", "Dark Flames");
            //     // unit.setAttribute("OverrideAttackEffectDuration", 5);
            // }
        },
        onAttackEnded: async (unit: Unit) => { // After the attack has resolved
            // TODO: Implement attribute getting/setting, unit.waitForChild, unit.configuration modification
            // const config = await unit.waitForChild("configuration", 10); // Placeholder
            // if (!config) return;

            // if (unit.getAttribute("KanzenSaiminMode") === true) { // If the attack was the special one
            //     const oldEffectName = unit.getAttribute("KanzenSaiminOldAttackEffectName");
            //     const oldEffectDuration = unit.getAttribute("KanzenSaiminOldAttackEffectDuration");

            //     // Restore original attack effect
            //     // if (oldEffectName !== undefined) config.AttackEffect.Value = oldEffectName;
            //     // if (oldEffectDuration !== undefined) config.AttackEffectDuration.Value = oldEffectDuration;

            //     // Clear override attributes
            //     // unit.removeAttribute("OverrideAttackEffectName");
            //     // unit.removeAttribute("OverrideAttackEffectDuration");

            //     unit.setAttribute("KanzenSaiminMode", false); // Consume the mode
            //     unit.setAttribute("KanzenSaiminOldAttackEffectName", undefined);
            //     unit.setAttribute("KanzenSaiminOldAttackEffectDuration", undefined);
            // }
        },
    },
};
