import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const BungeeCounter: PassiveData = {
    name: "Bungee Counter",
    description: "If Stunned, next attack does 300% more damage, and gains 1% more damage upto 5%.",
    callbacks: {
        onStunned: (unit: Unit) => {
            // TODO: Implement attribute setting
            // unit.setAttribute("StunnedApplied", true);
        },
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement attribute getting/setting and status effect checking (though StunnedApplied is an attribute here)
            // if (enemy && enemy.Health > 0 && unit.getAttribute("StunnedApplied")) {
            //     let stacks = unit.getAttribute("BungeeStacks") || 0;
            //     if (stacks < 0.05) { // Max 5% damage increase
            //         stacks += 0.01;
            //         unit.setAttribute("BungeeStacks", stacks);
            //         unit.setAttribute("PermanentDamageMulti", unit.getAttribute("PermanentDamageMulti") + 0.01);
            //     }
            //     // unit.setAttribute("StunnedApplied", false); // Assuming the buff is consumed after one attack
            //     return 3; // 300% more damage means multiplier of 3 (or 4 if it's original + 300%)
            // }
            return 1;
        },
    },
};
