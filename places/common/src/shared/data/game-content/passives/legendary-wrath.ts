import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const LegendaryWrath: PassiveData = {
    name: "Legendary Wrath",
    description: "+1% damage increase each attack, up to +50% boost",
    // maxPassiveStacks: 50, // Max stacks for the damage buff
    callbacks: {
        onAttack: async (unit: Unit) => {
            // TODO: Implement attribute getting/setting, unit.waitForChild
            // const config = await unit.waitForChild("configuration", 10); // Placeholder, may not be needed
            // let brolyStacksDamage = unit.getAttribute("BrolyStacksDamage") || 0;

            // if (brolyStacksDamage < LegendaryWrath.maxPassiveStacks) {
            //     brolyStacksDamage++;
            //     unit.setAttribute("BrolyStacksDamage", brolyStacksDamage);
            //     // Assuming PermanentDamageMulti is a multiplier like 1.0 for base, 1.01 for +1%
            //     unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + 0.01);
            // }
        },
    },
};
