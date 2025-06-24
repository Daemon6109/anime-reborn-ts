import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const SeaEmperor: PassiveData = {
    name: "Sea Emperor",
    description: "+0.5% DMG, Range, SPA each wave up to 5% boosts",
    // maxPassiveStacks: 10, // 5% / 0.5% = 10 stacks
    // percentPerStack: 0.005, // 0.5%
    callbacks: {
        onWave: async (unit: Unit) => {
            // TODO: Implement unit.waitForChild, attribute getting/setting
            // const config = await unit.waitForChild("configuration", 10); // Placeholder, may not be needed
            // let currentStacks = unit.getAttribute("KaidoSeaEmperorStacks") || 0;

            // if (currentStacks < (SeaEmperor.maxPassiveStacks || 10)) {
            //     currentStacks++;
            //     unit.setAttribute("KaidoSeaEmperorStacks", currentStacks);

            //     const statsToBuff = ["Damage", "Range", "AttackSpeed"];
            //     const buffAmount = SeaEmperor.percentPerStack || 0.005;

            //     for (const statName of statsToBuff) {
            //         const attributeName = `Permanent${statName}Multi`;
            //         let currentStatValue = unit.getAttribute(attributeName) || 1; // Assuming base is 1

            //         if (statName === "AttackSpeed") { // SPA decrease is a buff
            //             currentStatValue -= buffAmount;
            //         } else {
            //             currentStatValue += buffAmount;
            //         }
            //         unit.setAttribute(attributeName, currentStatValue);
            //     }
            // }
        },
    },
};
