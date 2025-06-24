import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const NumberOne: PassiveData = {
    name: "You Are Number 1", // Luau name: "You Are Number 1"
    description: "Ihigo gains +4% attack damage",
    // percentIncrease: 0.04,
    callbacks: {
        onPlace: async (unit: Unit) => {
            // TODO: Implement attribute getting/setting, unit.waitForChild
            // const config = await unit.waitForChild("configuration", 10); // Placeholder
            // if (config) {
            //     unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + NumberOne.percentIncrease);
            // }
        },
    },
};
