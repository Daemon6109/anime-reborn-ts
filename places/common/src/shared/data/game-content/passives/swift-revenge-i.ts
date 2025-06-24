import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const SwiftRevengeI: PassiveData = {
    name: "Swift Revenge I",
    description: "Chisota has a 75% chance to dodge enemy stuns, if she successfully dodges it, her next attack deals +200% more damage (CD 5s)",
    // dodgeChance: 0.75,
    // cooldown: 5, // seconds
    // damageBuffMultiplier: 2, // +200% more damage (additive to base of 1 for total 3x, or direct multiplier of 2?) Luau adds 2.
    // buffActiveTag: "SwiftRevengeIBuffActiveSR1", // SR1 for SwiftRevengeI
    // deductBuffTag: "SwiftRevengeIDeductSR1",
    // lastDodgeTickAttr: "SwiftRevengeILastTickSR1",
    // visualDodgeTag: "ChisotaDodgeSR1", // For client visual
    // visualDodgedEffectTag: "DodgedSR1",
    // visualDodgedEffectDuration: 1,
    callbacks: {
        onBeforeStun: (unit: Unit): boolean => {
            // TODO: Implement attribute getting/setting, tick(), task.delay, ReplicatedStorage.GameVariables.GameSpeed.Value
            // const lastDodgeTime = unit.getAttribute(SwiftRevengeI.lastDodgeTickAttr || "SwiftRevengeILastTickSR1") || 0;
            // const currentTime = tick(); // Placeholder

            // if ((currentTime - lastDodgeTime) >= (SwiftRevengeI.cooldown || 5)) {
            //     if (Math.random() < (SwiftRevengeI.dodgeChance || 0.75)) {
            //         unit.setAttribute(SwiftRevengeI.lastDodgeTickAttr || "SwiftRevengeILastTickSR1", currentTime);
            //         // unit.removeTag(SwiftRevengeI.visualDodgeTag || "ChisotaDodgeSR1");
            //         // unit.addTag(SwiftRevengeI.visualDodgeTag || "ChisotaDodgeSR1");
            //         // unit.addTag(SwiftRevengeI.visualDodgedEffectTag || "DodgedSR1");
            //         unit.addTag(SwiftRevengeI.buffActiveTag || "SwiftRevengeIBuffActiveSR1");

            //         const gameSpeed = game.GetService("ReplicatedStorage").GameVariables.GameSpeed.Value || 1; // Placeholder
            //         // task.delay((SwiftRevengeI.visualDodgedEffectDuration || 1) / gameSpeed, () => { // Placeholder
            //         //     if (unit && unit.getInstance()?.Parent) {
            //         //         unit.removeTag(SwiftRevengeI.visualDodgedEffectTag || "DodgedSR1");
            //         //     }
            //         // });
            //         return true; // Stun dodged
            //     }
            // }
            return false; // Stun not dodged
        },
        onAttack: (unit: Unit) => {
            // TODO: Implement attribute getting/setting, tag checking/adding
            // if (unit.hasTag(SwiftRevengeI.buffActiveTag || "SwiftRevengeIBuffActiveSR1")) {
            //     unit.removeTag(SwiftRevengeI.buffActiveTag || "SwiftRevengeIBuffActiveSR1");
            //     unit.addTag(SwiftRevengeI.deductBuffTag || "SwiftRevengeIDeductSR1");
            //     // Luau adds 2 to PermanentDamageMulti for +200%
            //     unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + (SwiftRevengeI.damageBuffMultiplier || 2));
            // }
        },
        onAttackEnded: (unit: Unit) => {
            // TODO: Implement attribute getting/setting, tag checking/removing
            // if (unit.hasTag(SwiftRevengeI.deductBuffTag || "SwiftRevengeIDeductSR1")) {
            //     unit.removeTag(SwiftRevengeI.deductBuffTag || "SwiftRevengeIDeductSR1");
            //     unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) - (SwiftRevengeI.damageBuffMultiplier || 2));
            // }
        },
    },
};
