import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const StrongestManAlive: PassiveData = {
    name: "Strongest Man Alive",
    description: "Greybeard gets +1% damage each wave, up to +20% boost",
    // maxPassiveStacks: 20,
    // percentPerStack: 0.01,
    callbacks: {
        onWave: async (unit: Unit) => {
            // TODO: Implement unit.waitForChild, attribute getting/setting
            // const config = await unit.waitForChild("configuration", 10); // Placeholder, may not be needed
            // let currentStacks = unit.getAttribute("StrongestManStacksSMA") || 0;

            // if (currentStacks < (StrongestManAlive.maxPassiveStacks || 20)) {
            //     currentStacks++;
            //     unit.setAttribute("StrongestManStacksSMA", currentStacks);
            //     unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + (StrongestManAlive.percentPerStack || 0.01));
            // }
        },
    },
};
