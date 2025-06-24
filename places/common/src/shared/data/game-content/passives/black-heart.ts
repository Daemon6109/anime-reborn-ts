import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const BlackHeart: PassiveData = {
    name: "Black Heart",
    description: "Every wave completed, Solo buffs all of his stats by 1.5% - Caps at 50%, Also buffs his summoned shadows' HP by 1.3% every wave - Caps at 40%",
    // statPerWave: 1.5, // Configuration specific to this passive
    // maxStats: 50, // Configuration specific to this passive
    callbacks: {
        onWave: async (unit: Unit) => {
            // TODO: Implement attribute getting/setting and unit.waitForChild
            // const config = await unit.waitForChild("configuration", 10);
            // const blackHeartStacks = unit.getAttribute("BlackHeartStacks") || 0;
            // const maxStacks = Math.floor(BlackHeart.maxStats / BlackHeart.statPerWave);
            // if (blackHeartStacks < maxStacks) {
            //     unit.setAttribute("BlackHeartStacks", blackHeartStacks + 1);
            //     for (const statName of ["Damage", "Range", "AttackSpeed"]) {
            //         const attrName = `Permanent${statName}Multi`;
            //         const currentBuff = unit.getAttribute(attrName) || 1; // Assuming default is 1
            //         let buffAmount = BlackHeart.statPerWave / 100;
            //         if (statName === "AttackSpeed") {
            //             buffAmount = -buffAmount;
            //         }
            //         unit.setAttribute(attrName, currentBuff + buffAmount);
            //     }
            // }
        },
    },
};
