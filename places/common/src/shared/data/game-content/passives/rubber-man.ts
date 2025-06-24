import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const RubberMan: PassiveData = {
    name: "Rubber Man",
    description: "Increases range by +10%",
    // percentIncrease: 0.1,
    callbacks: {
        onPlace: async (unit: Unit) => {
            // TODO: Implement attribute getting/setting, unit.waitForChild
            // const config = await unit.waitForChild("configuration", 10); // Placeholder
            // if (config) {
            //     unit.setAttribute("PermanentRangeMulti", (unit.getAttribute("PermanentRangeMulti") || 1) + (RubberMan.percentIncrease || 0.1));
            // }
        },
    },
};
