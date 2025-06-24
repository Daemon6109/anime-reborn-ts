import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const CarelessAcceleration: PassiveData = {
    name: "Careless Acceleration",
    description: "With a 10% chance does 50% more DMG for the attack, but with a 2% chance might get self-stunned for 5 seconds.",
    // percentIncrease: 0.5, // Configuration specific to this passive
    callbacks: {
        onAttack: (unit: Unit) => {
            // TODO: Implement attribute and tag equivalents, _G.UnitAPI (for SetTimedStunnedState)
            // const roll = math.random(1, 100); // Luau math.random(0,100) can be 0 to 100. Standard is 1 to 100.
            // // Clear previous buffs/tags from this passive
            // if (unit.hasTag("CarelessAcceleration")) {
            //     unit.removeTag("CarelessAcceleration");
            //     unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) - CarelessAcceleration.percentIncrease);
            // }
            // if (unit.hasTag("StunOnAttackEnd")) {
            //     unit.removeTag("StunOnAttackEnd");
            // }
            // if (roll <= 2) { // 2% chance for self-stun
            //     unit.addTag("StunOnAttackEnd");
            // } else if (roll <= 12) { // 10% chance for damage buff (12-2 = 10), ensuring it's not the stun roll
            //     unit.addTag("CarelessAcceleration");
            //     unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + CarelessAcceleration.percentIncrease);
            // }
        },
        onAttackEnded: (unit: Unit) => {
            // TODO: Implement attribute and tag equivalents, _G.UnitAPI
            // // Damage buff wears off after the attack
            // if (unit.hasTag("CarelessAcceleration")) {
            //     unit.removeTag("CarelessAcceleration");
            //     unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) - CarelessAcceleration.percentIncrease);
            // }
            // // Apply stun if tagged
            // if (unit.hasTag("StunOnAttackEnd")) {
            //     unit.removeTag("StunOnAttackEnd");
            //     // _G.UnitAPI.SetTimedStunnedState(unit, 5);
            // }
        },
    },
};
