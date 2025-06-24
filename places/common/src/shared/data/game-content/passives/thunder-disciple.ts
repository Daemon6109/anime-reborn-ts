import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const ThunderDisciple: PassiveData = {
    name: "Thunder Disciple",
    description: "Zenit deals +10% damage to bosses.",
    // percentIncreaseToBosses: 0.10,
    callbacks: {
        onPlace: async (unit: Unit) => {
            // TODO: Implement unit.waitForChild, attribute getting/setting
            // const config = await unit.waitForChild("configuration", 10); // Placeholder
            // if (config) {
            //     // Assuming PermanentDmgToBossMulti is an additive bonus (e.g., 0 for no bonus, 0.1 for +10%)
            //     unit.setAttribute("PermanentDmgToBossMulti", (unit.getAttribute("PermanentDmgToBossMulti") || 0) + (ThunderDisciple.percentIncreaseToBosses || 0.10));
            // }
        },
    },
};
