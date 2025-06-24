import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const NaturalVision: PassiveData = {
    name: "Natural Vision",
    description: "Twenty One has naturally +20% more range.",
    // percentIncrease: 0.2,
    callbacks: {
        onPlace: async (unit: Unit) => {
            // TODO: Implement attribute getting/setting, unit.waitForChild
            // const config = await unit.waitForChild("configuration", 10); // Placeholder
            // if (config) {
            //     unit.setAttribute("PermanentRangeMulti", (unit.getAttribute("PermanentRangeMulti") || 1) + NaturalVision.percentIncrease);
            // }
        },
    },
};
