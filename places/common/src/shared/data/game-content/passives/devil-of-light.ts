import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const DevilOfLight: PassiveData = {
    name: "Devil of Light",
    description: "Kuzar naturally attacks 15% quicker.",
    // percentIncrease: 0.15, // SPA decrease (quicker attacks)
    callbacks: {
        onPlace: async (unit: Unit) => {
            // TODO: Implement attribute setting, unit.waitForChild
            // const config = await unit.waitForChild("configuration", 10); // Ensure config is loaded if needed
            // if (config) {
            //     // Assuming PermanentAttackSpeedMulti is a multiplier where lower is faster (e.g., cooldown time)
            //     unit.setAttribute("PermanentAttackSpeedMulti", (unit.getAttribute("PermanentAttackSpeedMulti") || 1) - DevilOfLight.percentIncrease);
            // }
        },
    },
};
