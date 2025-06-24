import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const SwiftRevengeII: PassiveData = {
    name: "Swift Revenge II",
    description: "Chisota has a 100% chance to dodge enemy stuns, if she successfully dodges it, her next attack deals +200% more damage (CD 5s)",
    // dodgeChance: 1.00, // 100%
    // cooldown: 5, // seconds
    // damageBuffMultiplier: 2, // +200% damage
    // buffActiveTag: "SwiftRevengeIIBuffActiveSR2",
    // deductBuffTag: "SwiftRevengeIIDeductSR2",
    // lastDodgeTickAttr: "SwiftRevengeIILastTickSR2",
    // visualDodgeTag: "ChisotaDodgeSR2", // Luau uses same "ChisotaDodge"
    // visualDodgedEffectTag: "DodgedSR2", // Luau uses same "Dodged"
    // visualDodgedEffectDuration: 1,
    callbacks: {
        onBeforeStun: (unit: Unit): boolean => {
            // TODO: Implement attribute getting/setting, tick(), task.delay, ReplicatedStorage.GameVariables.GameSpeed.Value
            // const lastDodgeTime = unit.getAttribute(SwiftRevengeII.lastDodgeTickAttr || "SwiftRevengeIILastTickSR2") || 0;
            // const currentTime = tick(); // Placeholder

            // if ((currentTime - lastDodgeTime) >= (SwiftRevengeII.cooldown || 5)) {
            //     // Dodge chance is 100%
            //     unit.setAttribute(SwiftRevengeII.lastDodgeTickAttr || "SwiftRevengeIILastTickSR2", currentTime);
            //     // unit.removeTag(SwiftRevengeII.visualDodgeTag || "ChisotaDodgeSR2");
            //     // unit.addTag(SwiftRevengeII.visualDodgeTag || "ChisotaDodgeSR2");
            //     // unit.addTag(SwiftRevengeII.visualDodgedEffectTag || "DodgedSR2");
            //     unit.addTag(SwiftRevengeII.buffActiveTag || "SwiftRevengeIIBuffActiveSR2");

            //     const gameSpeed = game.GetService("ReplicatedStorage").GameVariables.GameSpeed.Value || 1; // Placeholder
            //     // task.delay((SwiftRevengeII.visualDodgedEffectDuration || 1) / gameSpeed, () => { // Placeholder
            //     //     if (unit && unit.getInstance()?.Parent) {
            //     //         unit.removeTag(SwiftRevengeII.visualDodgedEffectTag || "DodgedSR2");
            //     //     }
            //     // });
            //     return true; // Stun dodged
            // }
            return false; // On cooldown
        },
        onAttack: (unit: Unit) => {
            // TODO: Implement attribute getting/setting, tag checking/adding
            // if (unit.hasTag(SwiftRevengeII.buffActiveTag || "SwiftRevengeIIBuffActiveSR2")) {
            //     unit.removeTag(SwiftRevengeII.buffActiveTag || "SwiftRevengeIIBuffActiveSR2");
            //     unit.addTag(SwiftRevengeII.deductBuffTag || "SwiftRevengeIIDeductSR2");
            //     // unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + (SwiftRevengeII.damageBuffMultiplier || 2));
            // }
        },
        onAttackEnded: (unit: Unit) => {
            // TODO: Implement attribute getting/setting, tag checking/removing
            // if (unit.hasTag(SwiftRevengeII.deductBuffTag || "SwiftRevengeIIDeductSR2")) {
            //     unit.removeTag(SwiftRevengeII.deductBuffTag || "SwiftRevengeIIDeductSR2");
            //     // unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) - (SwiftRevengeII.damageBuffMultiplier || 2));
            // }
        },
    },
};
