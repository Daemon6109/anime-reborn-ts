import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const MasteredWeapons: PassiveData = {
    name: "Master of weapons", // Luau name: "Master of weapons"
    description: "Gains +10% more damage",
    // percentIncrease: 0.1,
    callbacks: {
        onPlace: async (unit: Unit) => {
            // TODO: Implement attribute getting/setting, unit.waitForChild
            // const config = await unit.waitForChild("configuration", 10); // Placeholder
            // if (config) {
            //     unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + MasteredWeapons.percentIncrease);
            // }
        },
    },
};
