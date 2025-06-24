import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const SpiritWarrior: PassiveData = {
    name: "Spirit Warrior",
    description: "+10% increased damage.",
    // percentIncrease: 0.1,
    callbacks: {
        onPlace: async (unit: Unit) => {
            // TODO: Implement attribute getting/setting, unit.waitForChild
            // const config = await unit.waitForChild("configuration", 10); // Placeholder
            // if (config) {
            //     unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + (SpiritWarrior.percentIncrease || 0.1));
            // }
        },
    },
};
