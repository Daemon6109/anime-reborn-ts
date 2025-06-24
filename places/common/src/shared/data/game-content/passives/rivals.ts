import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const Rivals: PassiveData = {
    name: "Rivals",
    description: "Sasuke gets +5% damage increase and -5% attack speed decrease.",
    // percentStatChange: 0.05, // Used for both damage up and SPA down
    callbacks: {
        onPlace: async (unit: Unit) => {
            // TODO: Implement unit.waitForChild, attribute getting/setting
            // const config = await unit.waitForChild("configuration", 10); // Placeholder
            // if (config) {
            //     const change = Rivals.percentStatChange || 0.05;
            //     // SPA decrease means lower is faster, so subtract from the multiplier if it represents cooldown/delay
            //     unit.setAttribute("PermanentAttackSpeedMulti", (unit.getAttribute("PermanentAttackSpeedMulti") || 1) - change);
            //     unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + change);
            // }
        },
    },
};
