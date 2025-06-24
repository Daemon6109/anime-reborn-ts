import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const BeastInstincts: PassiveData = {
    name: "Beast Instincts",
    description: "Inoke naturally has +7.5% more damage.",
    // percentIncrease: 0.075, // This seems to be a configuration specific to this passive
    callbacks: {
        onPlace: async (unit: Unit) => {
            // TODO: Figure out how to handle PermanentDamageMulti attribute and unit.waitForChild
            // const config = await unit.waitForChild("configuration", 10);
            // if (config) {
            //     unit.setAttribute("PermanentDamageMulti", unit.getAttribute("PermanentDamageMulti") + BeastInstincts.percentIncrease);
            // }
        },
    },
};
