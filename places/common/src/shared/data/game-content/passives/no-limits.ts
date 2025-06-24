import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const NoLimits: PassiveData = {
    name: "No Limits",
    description: "+15% increased range",
    // percentIncrease: 0.15,
    callbacks: {
        onPlace: async (unit: Unit) => {
            // TODO: Implement attribute getting/setting, unit.waitForChild
            // const config = await unit.waitForChild("configuration", 10); // Placeholder
            // if (config) {
            //     unit.setAttribute("PermanentRangeMulti", (unit.getAttribute("PermanentRangeMulti") || 1) + NoLimits.percentIncrease);
            // }
        },
    },
};
