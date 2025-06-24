import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const Hitman: PassiveData = {
    name: "Hitman",
    description: "Gains +0.1% more damage per elimination (MAX 15%)",
    // maxPassiveStacks: 150, // 15% / 0.1% = 150 kills for max bonus
    // percentPerStack: 0.001, // 0.1% damage increase per kill
    callbacks: {
        onKill: (unit: Unit) => {
            // TODO: Implement attribute getting/setting
            // let stacks = unit.getAttribute("HitmanStacks") || 0;
            // if (stacks < Hitman.maxPassiveStacks) {
            //     stacks++;
            //     unit.setAttribute("HitmanStacks", stacks);
            //     unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + Hitman.percentPerStack);
            // }
        },
    },
};
