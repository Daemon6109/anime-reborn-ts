import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const HeavyHits: PassiveData = {
    name: "Heavy Hits",
    description: "Deals +100% more damage to bosses", // Also: "onKill boss, gain +0.1 DmgToBossMulti up to 8 times (total +80%)"
    // percentIncrease: 1, // Initial +100% damage to bosses (means 2x damage)
    callbacks: {
        onPlace: (unit: Unit) => {
            // TODO: Implement attribute getting/setting, unit.waitForChild
            // const config = await unit.waitForChild("configuration", 10); // Placeholder for async
            // if (config) {
            //     // Assuming PermanentDmgToBossMulti is a multiplier, e.g., 1 is normal, 2 is double.
            //     // "+100% more damage" means current value + 1.0 * base.
            //     // If PermanentDmgToBossMulti is the *additional* multiplier, then it's +1.
            //     unit.setAttribute("PermanentDmgToBossMulti", (unit.getAttribute("PermanentDmgToBossMulti") || 0) + HeavyHits.percentIncrease);
            // }
        },
        onKill: (unit: Unit, killedEnemy: any) => {
            // TODO: Implement attribute getting/setting, enemy.IsBoss check
            // if (killedEnemy && killedEnemy.IsBoss) {
            //     let stacks = unit.getAttribute("HeavyHitStacks") || 0;
            //     const maxStacks = 8; // Can stack buff 8 times
            //     const buffPerStack = 0.1; // 10% additional DmgToBossMulti per stack

            //     if (stacks < maxStacks) {
            //         unit.setAttribute("HeavyHitStacks", stacks + 1);
            //         unit.setAttribute("PermanentDmgToBossMulti", (unit.getAttribute("PermanentDmgToBossMulti") || 0) + buffPerStack);
            //     }
            // }
        },
    },
};
