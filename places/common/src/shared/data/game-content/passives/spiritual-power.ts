import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const SpiritualPower: PassiveData = {
    name: "Spiritual Power",
    description: "This unit has 25% chance to slow down the enemies",
    // procChance: 0.25, // 25%
    callbacks: {
        onAttack: (unit: Unit) => {
            // TODO: Implement attribute setting.
            // This passive sets a "PassiveSlow" attribute on the unit if it procs.
            // The actual application of "Slow" status effect to the enemy would be handled
            // by the attack/damage system when it sees this attribute is true for the attack.
            // unit.setAttribute("PassiveSlow", false); // Default for this attack
            // if (Math.random() < (SpiritualPower.procChance || 0.25)) { // Luau: math.random(1,4) == 1
            //     unit.setAttribute("PassiveSlow", true);
            // }
        },
        // onAttackHit: (unit: Unit, enemy: any) => {
        //     // if (unit.getAttribute("PassiveSlow") === true) {
        //     //     // Apply Slow status effect to enemy here
        //     //     // _G.Registry.registry.StatusEffects.Slow.OnServer(unit, [enemy], duration); // Duration?
        //     // }
        //     // // Reset for next attack if it's a per-attack flag
        //     // unit.setAttribute("PassiveSlow", false);
        // }
    },
};
