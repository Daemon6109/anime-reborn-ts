import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const TripleBlade: PassiveData = {
    name: "Triple Blade",
    description: "Zoro gains 10% attack damage.",
    // percentIncrease: 0.1,
    callbacks: {
        onPlace: async (unit: Unit) => {
            // TODO: Implement unit.waitForChild, attribute getting/setting
            // const config = await unit.waitForChild("configuration", 10); // Placeholder
            // if (config) {
            //     unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + (TripleBlade.percentIncrease || 0.1));
            // }
        },
    },
};
