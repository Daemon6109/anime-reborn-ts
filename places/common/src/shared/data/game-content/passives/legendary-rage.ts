import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const LegendaryRage: PassiveData = {
    name: "Legendary Rage",
    description: "+1% range increase each attack, up to +20% boost",
    // maxPassiveStacks: 20, // Max stacks for the range buff
    callbacks: {
        onAttack: async (unit: Unit) => {
            // TODO: Implement attribute getting/setting, unit.waitForChild
            // const config = await unit.waitForChild("configuration", 10); // Placeholder, may not be needed if only attributes are used
            // let brolyStacksRange = unit.getAttribute("BrolyStacksRange") || 0;

            // if (brolyStacksRange < LegendaryRage.maxPassiveStacks) {
            //     brolyStacksRange++;
            //     unit.setAttribute("BrolyStacksRange", brolyStacksRange);
            //     // Assuming PermanentRangeMulti is a multiplier like 1.0 for base, 1.01 for +1%
            //     unit.setAttribute("PermanentRangeMulti", (unit.getAttribute("PermanentRangeMulti") || 1) + 0.01);
            // }
        },
    },
};
